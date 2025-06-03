import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:fingo/provider/exam_provider.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EvaluateWidget extends StatefulWidget {
  final String targetSign;

  const EvaluateWidget({
    Key? key,
    required this.targetSign,
  }) : super(key: key);

  @override
  _EvaluateWidgetState createState() => _EvaluateWidgetState();
}

class _EvaluateWidgetState extends State<EvaluateWidget> {
  late ExamProvider _examProvider;
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isChecking = false;
  bool _isCapturing = false;
  String _feedback = "";

  List<Uint8List> _frameBuffer = [];
  List<String> _frameBufferString = [];
  final int _maxBufferSize = 30;

  final http.Client _client = http.Client();

  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  final String _apiUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setupIsolate();
    _examProvider = Provider.of<ExamProvider>(context, listen: false);
  }

  Future<void> _setupIsolate() async {
    _receivePort = ReceivePort();
    _isolate =
        await Isolate.spawn(_imageProcessIsolate, _receivePort!.sendPort);

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is Map) {
        _handleApiResponse(message);
      }
    });
  }

  static void _imageProcessIsolate(SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    final client = http.Client();
    receivePort.listen((message) async {
      if (message is Map) {
        final String apiUrl = message['apiUrl'];
        final String endpoint = message['endpoint'];
        final Map<String, dynamic> data = message['data'];

        try {
          final response = await client.post(
            Uri.parse('$apiUrl/$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          );
          try {
            if (response.statusCode == 200) {
              final dynamic jsonResponse = json.decode(response.body);
              if (jsonResponse is Map<String, dynamic>) {
                jsonResponse['endpoint'] = endpoint;
                sendPort.send(jsonResponse);
              } else {
                sendPort.send({
                  'error':
                      'Invalid response format: expected Map, got ${jsonResponse.runtimeType}',
                  'endpoint': endpoint,
                  'success': false
                });
              }
            } else {
              String errorBody;
              try {
                final dynamic errorJson = json.decode(response.body);
                errorBody = errorJson.toString();
              } catch (e) {
                errorBody = response.body;
              }
              sendPort.send({
                'error': 'API error: ${response.statusCode} - $errorBody',
                'endpoint': endpoint,
                'success': false
              });
            }
          } catch (e) {
            sendPort.send({
              'error': 'Failed to parse response: ${e.toString()}',
              'endpoint': endpoint,
              'success': false
            });
          }
        } catch (e) {
          print('Error in isolate: $e');
          sendPort.send(
              {'error': e.toString(), 'endpoint': endpoint, 'success': false});
        }
      }
    });
  }

  void _handleApiResponse(Map response) {
    if (response.containsKey('error')) {
      print("Error from API: ${response['error']}");
      setState(() {
        _examProvider.setFeedback("Error processing sign. Please try again.");
        _examProvider.setIsCorrect(false);
        _examProvider.nextPage();
      });
      return;
    }

    final endpoint = response['endpoint'] as String?;
    if (endpoint == null) {
      print("No endpoint in response");
      return;
    }

    if (endpoint == 'detect_sign_batch') {
      setState(() {
        _isChecking = false;
        bool detected = false;
        String predictedSign = '';
        double confidence = 0.0;

        try {
          detected = response['detected'] as bool? ?? false;
          predictedSign = response['predicted_sign'] as String? ?? '';
          confidence = (response['confidence'] as num?)?.toDouble() ?? 0.0;
        } catch (e) {
          print("Error parsing response values: $e");
        }

        print(
            "Detection result - Detected: $detected, Sign: $predictedSign, Confidence: $confidence");

        if (detected) {
          _examProvider.setFeedback("Correct! Good job!");
          _examProvider.setIsCorrect(true);
          _examProvider.nextPage();
        } else {
          _examProvider.setFeedback("Not quite right! Try again!");
          _examProvider.setIsCorrect(false);
          _examProvider.nextPage();
        }
      });
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      ),
      ResolutionPreset.low,
      imageFormatGroup: ImageFormatGroup.yuv420,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      await _controller.setExposureOffset(-1.0);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startGame() async {
    setState(() {
      _isPlaying = true;
    });

    await _showCountdown();
    _startCapturing();
  }

  Future<void> _showCountdown() async {
    for (int i = 2; i > 0; i--) {
      setState(() {
        _feedback = i.toString();
      });
      await Future.delayed(Duration(seconds: 1));
    }
    setState(() {
      _feedback = "GO!";
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _feedback = "";
    });
  }

  Future<void> _processAndSendFrames() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    try {
      await _stopCapturing();

      if (!_controller.value.isPreviewPaused) {
        await _controller.pausePreview();
      }

      _frameBufferString =
          _frameBuffer.map((bytes) => utf8.decode(bytes)).toList();

      print("Send frames");
      _sendPort?.send({
        'apiUrl': _apiUrl,
        'endpoint': 'detect_sign_batch',
        'data': {
          'images': _frameBufferString,
          'target_sign': widget.targetSign.split(',').first,
        }
      });
    } catch (e) {
      print('Error in _processAndSendFrames: $e');
      setState(() {
        _isChecking = false;
        _examProvider.setFeedback("Error processing frames. Please try again.");
        _examProvider.setIsCorrect(false);
        _examProvider.nextPage();
      });
    }
  }

  Future<void> _startCapturing() async {
    if (_isChecking || !mounted) return;

    try {
      await _stopCapturing();

      _frameBuffer.clear();
      _frameBufferString.clear();
      _isCapturing = false;

      if (_controller.value.isPreviewPaused) {
        await _controller.resumePreview();
      }

      await _controller.startImageStream((CameraImage image) {
        if (!_isChecking && _frameBuffer.length < _maxBufferSize && mounted) {
          _processImage(image);
        } else if (_frameBuffer.length >= _maxBufferSize &&
            !_isChecking &&
            mounted) {
          _stopCapturing().then((_) => _processAndSendFrames());
        }
      });
    } catch (e) {
      print('Error starting image stream: $e');
      _isCapturing = false;
    }
  }

  Future<void> _stopCapturing() async {
    try {
      if (_controller.value.isStreamingImages) {
        await _controller.stopImageStream();
      }
    } catch (e) {
      print('Error stopping image stream: $e');
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isCapturing) return;
    _isCapturing = true;
    print(image.width);
    print(image.height);

    try {
      final Map<String, dynamic> imageData = {
        'width': image.width,
        'height': image.height,
        'yPlane': base64Encode(image.planes[0].bytes),
        'uPlane': base64Encode(image.planes[1].bytes),
        'vPlane': base64Encode(image.planes[2].bytes),
        'yRowStride': image.planes[0].bytesPerRow,
        'uvRowStride': image.planes[1].bytesPerRow,
        'uvPixelStride': image.planes[1].bytesPerPixel,
        'orientation': 'portrait', // Add orientation information
        'isFrontCamera': true,
      };

      setState(() {
        _frameBuffer
            .add(Uint8List.fromList(utf8.encode(json.encode(imageData))));
      });
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isCapturing = false;
    }
  }

  @override
  void dispose() {
    _stopCapturing().then((_) {
      _controller.dispose();
      _client.close();
      _isolate?.kill(priority: Isolate.immediate);
      _receivePort?.close();
      super.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(
          child: CircularProgressIndicator(
        color: AppTheme.mainBlue,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_isChecking)
          Column(
            children: [
              Text(
                'Sign this word:',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.targetSign.toUpperCase(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        Stack(
          alignment: Alignment.center,
          children: [
            if (!_isChecking)
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                // No rotation on Z axis
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CameraPreview(_controller),
                ),
              ),
            if (!_isChecking)
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Image.asset("lib/image/person_outline.png")),
            if (_isChecking)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.mainBlue,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Processing sign...',
                      style: TextStyle(
                        color: AppTheme.mainBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (_isPlaying && !_isChecking)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.photo_camera, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Frames: ${_frameBuffer.length}/$_maxBufferSize',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_feedback != "")
              Container(
                color: Colors.white.withAlpha(100),
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _feedback.isEmpty ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedScale(
                      scale: _feedback.isEmpty ? 0.8 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _feedback,
                        style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
        Container(
          padding: EdgeInsets.only(bottom: 30),
          child: !_isPlaying
              ? CustomizedButton(
                  title: 'Start Recording',
                  func: _startGame,
                )
              : SizedBox(
                  height: 50,
                ),
        ),
      ],
    );
  }
}

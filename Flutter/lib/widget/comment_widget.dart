import 'package:fingo/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/comment.dart';
import '../resource/CRUD/student_controller.dart';
import '../utils/image.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;

  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isLoading = false;
  late StudentController _studentController;
  String _username = "";
  String _profileUrl = "";

  @override
  void initState() {
    super.initState();
    _studentController = StudentController();
    _loadContent();
  }

  void _loadContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _studentController.getUser(widget.comment.userId);
      setState(() {
        _username = user.name;
        _profileUrl = user.profilePic!;
      });
    } catch (e) {
      print("Error fetching username: $e");
      setState(() {
        _username = "Anonymous";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        decoration: AppTheme.widgetDeco(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: _isLoading
            ? Center(
              child: CircularProgressIndicator(
                  color: AppTheme.mainOrange,
                ),
            )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                // );
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: networkImage(_profileUrl, 35)))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            getTimeAgo(widget.comment.createdAt),
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(height: 7),
                  Text(
                    widget.comment.content,
                    style: TextStyle(height: 1.2, fontSize: 13.5),
                  ),
                ],
              ),
      ),
    );
  }
}

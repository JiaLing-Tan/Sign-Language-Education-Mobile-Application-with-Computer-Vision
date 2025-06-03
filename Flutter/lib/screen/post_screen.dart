import 'package:fingo/resource/CRUD/post_controller.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:fingo/widget/customized_text_box.dart';
import 'package:fingo/widget/customized_text_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../model/post.dart';
import '../provider/user_provider.dart';
import '../utils/location.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  PostController _postController = PostController();
  bool _isChecked = true;
  bool _isLoading = false;
  bool _isShowingDialog = false;

  createPost(UserProvider userProvider) async {
    setState(() {
      _isLoading = true;
    });
    double? latitude;
    double? longitude;

    if (_isChecked) {
      List location = await getCurrentLocation();
      print(location);
      if (location.length == 1) {
        showSnackBar(location.elementAtOrNull(0), context);
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        latitude = location.elementAt(0);
        longitude = location.elementAt(1);
      }
    }
    final post = Post(
        id: "",
        userId: userProvider.user.id,
        createdAt: DateTime.now(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        longitude: longitude,
        latitude: latitude);
    await _postController.createPost(post);
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _isShowingDialog = true;
      _isLoading = false;
    });
    showSnackBar("Post successfully created!", context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) {
        if (_isShowingDialog) return;

        _isShowingDialog = true;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            showBackDialog(
                function: () {
                  Navigator.of(context).pop();
                },
                context: context,
                question:
                    "Are you sure you want to leave? \nAll draft will be discarded!");
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 10, bottom: 10),
                child: Text(
                  "Title",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              CustomizedTextField(
                  controller: _titleController,
                  hintText: "Your post title",
                  textInputType: TextInputType.text),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 20, bottom: 10),
                child: Text(
                  "Content",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              CustomizedTextBox(
                  controller: _contentController, hintText: "Your content"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                      activeColor: AppTheme.mainBlue,
                      checkColor: Colors.white,
                    ),
                    Text("Share post to user nearby.")
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: CustomizedButton(
                  func: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_isLoading) {
                      showSnackBar("Give me a second please!", context);
                    } else {
                      if (_titleController.text.trim().isEmpty ||
                          _contentController.text.trim().isEmpty) {
                        showSnackBar(
                            "Title and content cannot be blank!", context);
                        return;
                      }
                      await createPost(_userProvider);
                    }
                  },
                  color: AppTheme.mainBlue,
                  title: "Post",
                  width: double.infinity,
                  isLoading: _isLoading,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

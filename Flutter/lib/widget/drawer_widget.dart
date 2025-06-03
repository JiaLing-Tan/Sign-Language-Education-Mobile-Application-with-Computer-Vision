import 'package:another_flushbar/flushbar.dart';
import 'package:fingo/resource/auth_method.dart';
import 'package:fingo/utils/image.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_text_box.dart';
import 'package:fingo/widget/customized_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool _isEdit = false;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final _user = userProvider.user;
    final authService = Authentication();
    double _width = MediaQuery.of(context).size.width;
    return Drawer(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30.0, top: 50, bottom: 50, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(_width),
                    child: networkImage(_user.profilePic!, _width / 3)),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hi, ",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          _user.name!,
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dashed,
                              fontSize: 17),
                        ),
                      ],
                    ),
                    IconButton(
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            _isEdit = true;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                _isEdit
                    ? Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: CustomizedTextField(
                                horizontalPadding: 0,
                                controller: _textEditingController,
                                hintText: "Your new name",
                                textInputType: TextInputType.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // the '2023' part
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () => showBackDialog(
                                  context: context,
                                  question: "Discard Change?",
                                  function: () {
                                    setState(() {
                                      _isEdit = false;
                                      _textEditingController.clear();
                                    });
                                  }),
                              icon: Icon(Icons.close)),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                if (_textEditingController.text.trim().length <
                                    4) {
                                  Flushbar(
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    backgroundColor: AppTheme.mainBlue,
                                    messageText: Text(
                                      "Name should not be less than 4 characters",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    // message:  "Not enough coins!",
                                    duration: Duration(seconds: 1),
                                  )..show(context);
                                } else if (_textEditingController.text.trim() ==
                                    _user.name) {
                                  Flushbar(
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    backgroundColor: AppTheme.mainBlue,
                                    messageText: Text(
                                      "New name cannot be the same as old name!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    // message:  "Not enough coins!",
                                    duration: Duration(seconds: 1),
                                  )..show(context);
                                } else {
                                  showBackDialog(
                                      context: context,
                                      question: "Save Change?",
                                      function: () {
                                        setState(() {
                                          _isEdit = false;
                                          userProvider.updateName(
                                              _textEditingController.text
                                                  .trim());
                                        });
                                      });
                                }
                              },
                              icon: Icon(Icons.check))
                        ],
                      )
                    : SizedBox()
              ],
            ),
            GestureDetector(
                onTap: () {
                  showBackDialog(
                      context: context,
                      question: "Are you sure you want to sign out?",
                      function: (){authService.signOut();});
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign out",
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(Icons.exit_to_app),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

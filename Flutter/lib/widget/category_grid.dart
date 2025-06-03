import 'package:fingo/model/lesson.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/category_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../resource/CRUD/lesson_controller.dart';

class CategoryGrid extends StatefulWidget {
  final bool isClass;
  final bool isPath;

  const CategoryGrid({Key? key, this.isClass = true, this.isPath = false})
      : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid>
    with AutomaticKeepAliveClientMixin<CategoryGrid> {
  final LessonController _lessonController = LessonController();

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required when using AutomaticKeepAliveClientMixin

    return StreamBuilder<List<Lesson>>(
      stream: _lessonController.getClassStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CircularProgressIndicator(
                color: widget.isClass ? AppTheme.mainOrange : AppTheme.mainBlue,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          List<Lesson> lessonList = snapshot.data!;
          lessonList.sort((a, b) => a.id.compareTo(b.id));
          return widget.isPath
              ? ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 15,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lessonList.length,
                  itemBuilder: (_, index) {
                    final lesson = lessonList[index];
                    return CategoryWidget(
                      lesson: lesson,
                      isClass: widget.isClass,
                      isPath: true,
                    );
                  },
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: lessonList.length + 2,
                  itemBuilder: (_, index) {
                    if (index < lessonList.length) {
                      final lesson = lessonList[index];
                      return CategoryWidget(
                        lesson: lesson,
                        isClass: widget.isClass,
                      );
                    } else {
                      return Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Center(
                          child: Text(
                            "Coming soon!",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.grayText),
                          ),
                        ),
                        decoration: AppTheme.widgetDeco(),
                      );
                    }
                  },
                );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
              child: Column(
            children: [
              Text("Urghhh, I'm trying to get the content, try reload!"),
              GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Text(
                  "Reload",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

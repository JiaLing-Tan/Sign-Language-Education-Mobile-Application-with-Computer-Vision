import 'package:another_flushbar/flushbar.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class FoodMenu extends StatelessWidget {
  const FoodMenu({super.key});

  static void showFoodMenu(context) {
    final foodKeys = foodToExperience.keys.toList();
    final width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    feed(int price, int exp, context) {
      if (userProvider.user.coins >= price) {
        showSnackBar("Purchased successfully!", context);
        Navigator.pop(context);
        userProvider.startAnimation();
        userProvider.updateCoins(-price);
        userProvider.updateLevel(exp);
      } else {
        Flushbar(
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: AppTheme.mainBlue,
          messageText: Text(
            "Not enough coins!",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          // message:  "Not enough coins!",
          duration: Duration(seconds: 1),
        )..show(context);
      }
    }

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Food Menu',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  )
                ]),
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                          maxCrossAxisExtent: width,
                          mainAxisExtent: width * 0.7),
                      itemBuilder: (_, i) {
                        final price = foodKeys[i];
                        final experience = foodToExperience[price];
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                          decoration: AppTheme.widgetDeco(
                              color: Colors.white.withAlpha(150)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "lib/image/food_$i.png",
                                width: width * 0.3,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$experience exp",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  feed(price, experience!, dialogContext);
                                  FocusScope.of(context).unfocus();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: AppTheme.widgetDeco(
                                      color: AppTheme.mainOrange),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "lib/image/paw.png",
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        price.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: 3,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFoodMenu(context);
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 5,
              child: Image.asset(
                "lib/image/food_bowl.png",
                height: 55,
              ),
            ),
            Positioned(
                bottom: 5,
                child: Text(
                  "Feed!",
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ))
          ],
        ),
      ),
    );
  }
}

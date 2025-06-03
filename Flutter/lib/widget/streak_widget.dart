import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final streakDay = userProvider.user.streakDay;

    claimStreak() {
      userProvider.claimStreak();
      if (userProvider.user.streakDay == 7) {
        userProvider.updateCoins(150);
      } else {
        userProvider.updateCoins(userProvider.user.streakDay%2 == 0? 100: 50);
      }
    }



    return Container(
      decoration: AppTheme.widgetDeco(color: AppTheme.mainOrange),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5),
              child: Text(
                "${userProvider.user.streakDay} days on streak !",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _width - 30 - 100,
                  child: GridView.builder(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3 / 4),
                    itemBuilder: (_, i) => Column(spacing: 5, children: [
                      Text(
                        "Day ${i + 1}",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 0),
                        // height: 70,
                        decoration: AppTheme.widgetDeco(
                            isLuminous: i == streakDay,
                            color: i == streakDay
                                ? Colors.white
                                : Colors.white.withAlpha(150)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            i % 2 != 0
                                ? Stack(children: [
                                    Image.asset(
                                        height: 15, "lib/image/paw.png"),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 5),
                                      child: Image.asset(
                                          height: 25, "lib/image/paw.png"),
                                    )
                                  ])
                                : i == 6
                                    ? Image.asset(
                                        height: 30, "lib/image/fire.png")
                                    : Image.asset(
                                        height: 30, "lib/image/paw.png"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              i != 6
                                  ? "${50 + (i % 2) * 50}\ncoins"
                                  : "150\ncoins",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 0.8,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                    itemCount: 6,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Day 7",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                      height: ((_width - 130 - 10) * (3 / 4)) - 15,
                      decoration: AppTheme.widgetDeco(
                          isLuminous: streakDay == 6,
                          color: streakDay == 6
                              ? Colors.white
                              : Colors.white.withAlpha(150)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(height: 70, "lib/image/fire.png"),
                          Text(
                            "150\ncoins",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 0.8,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: DateUtils.isSameDay(
                      userProvider.user.lastClaimed, DateTime.now())
                  ? CustomizedButton(
                      func: () {},
                      color: AppTheme.mainOrange,
                      title: "Comeback tomorrow!",
                      width: double.infinity,
                    )
                  : CustomizedButton(
                      func: claimStreak,
                      color: AppTheme.mainBlue,
                      title: "Claim!",
                      width: double.infinity,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

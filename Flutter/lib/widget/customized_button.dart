import 'package:fingo/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  final String title;
  final bool isRoundButton;
  final IconData icon;
  final void Function() func;
  final Color color;
  final String tooltip;
  final double width;
  final bool isLoading;
  final double height;
  final Color titleColor;

  const CustomizedButton(
      {super.key,
        this.height = 50,
        this.title = "",
        this.isRoundButton = false,
        this.icon = Icons.add,
        this.color = AppTheme.mainOrange,
        this.tooltip = "",
        this.width = 200,
        required this.func,
        this.isLoading = false,
        this.titleColor = Colors.white
      });

  @override
  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: tooltip == "" ? false : true,
      child: Tooltip(
        // textStyle: TextStyle(color: Colors.black),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey.withOpacity(0.5)),
        triggerMode: TooltipTriggerMode.longPress,
        message: tooltip,
        child: GestureDetector(
          onTap: func,
          child: Container(
            alignment: Alignment.center,
            width: isRoundButton ? height : width,
            height: height,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4))],
              color: color,
              borderRadius: BorderRadius.circular(25),
            ),
            child: isLoading? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.white,),
            ):isRoundButton
                ? Icon(
              icon,
              color: Colors.white,
            )
                : Text(
              title,
              style: TextStyle(
                  color: titleColor, fontSize: 16, fontWeight: FontWeight.w600)
            ),
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData icon;
  final void Function() func;
  const RoundButton({
    Key? key,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4))]),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
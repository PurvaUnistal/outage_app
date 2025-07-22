import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'res/common_style.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon; // optional icon
  final double iconSize;
  final Color? iconColor;

  const ButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.iconSize = 20,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: CommonStyle.gradients,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? Colors.white,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: Styles.btnText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback  onTap;
  final IconData  iconData;
  const CircleButton({super.key, required this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width * 0.1;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: EnvironmentConfig.of(context)!.primaryTheme, // inner circle
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size:  buttonSize * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}

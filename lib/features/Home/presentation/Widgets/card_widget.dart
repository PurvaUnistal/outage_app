import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final String path;
  final double? imageWidth;
  final double? imageHeight;

  const CardWidget({
    Key? key,
    required this.text,
    required this.path,
    this.imageWidth,
    this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          Image.asset(
            path,
            width: imageWidth ?? 100, // Default to 100 if not provided
            height: imageHeight ?? 100, // Default to 100 if not provided
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 8), // Spacing between image and text

          // Text
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: Styles.count,
              textAlign: TextAlign.center, // Align text in the center
            ),
          ),
        ],
      ),
    );
  }
}

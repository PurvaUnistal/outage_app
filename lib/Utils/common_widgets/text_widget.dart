import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;

  const TextWidget(
      this.text, {
        super.key,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.color,
        this.fontWeight,
        this.fontSize,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: Styles.bodySmall.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}

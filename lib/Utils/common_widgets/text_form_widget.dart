import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

import 'res/common_style.dart';
import 'res/environment_config.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? star;
  final String? label;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final ValueChanged<String>? onChanged;
  final bool? obscureText;
  final TextInputType? inputType;
  final int? maxLength;
  final int? maxLine;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? enabled;
  final bool? autofocus;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  TextFieldWidget({
    Key? key,
    this.focusNode,
    this.initialValue,
    this.star,
    this.label,
    this.hintText,
    this.labelText,
    this.counterText,
    this.autofillHints,
    this.controller,
    this.obscureText,
    this.onChanged,
    this.inputType,
    this.maxLength,
    this.maxLine,
    this.onTap,
    this.onFieldSubmitted,
    this.enabled,
    this.autofocus,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: EnvironmentConfig.of(context)!.primaryTheme,
      focusNode: focusNode,
      autofillHints: autofillHints,
      onTap: onTap,
      autofocus: autofocus ?? false,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled ?? true,
      maxLength: maxLength,
      maxLines: maxLine ?? 1,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      validator: validator ?? null,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: inputFormatters,
      style: Styles.texts,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        // labelText: "${star ?? ""}${label ?? ""}",
        counterText: "",
        label: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(flex: 1, child: Text(star ?? "", style: Styles.stars)),
              Flexible(
                flex: 6,
                child: Text(label ?? "", style: Styles.labels),
              ),
            ],
          ),
        ),
        hintStyle: Styles.labels,
        fillColor: AppColor.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: maxLine != null ? 8 : 0),
        border: CommonStyle.border,
        focusedBorder: CommonStyle.border,
        disabledBorder: CommonStyle.border,
        enabledBorder: CommonStyle.border,
        errorBorder: CommonStyle.borderRed,
        errorStyle:Styles.subStar,
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'WidgetStyles/common_style.dart';
import 'res/app_color.dart';
import 'res/app_styles.dart';

//ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? star;
  final String? label;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final String? hintText;
  final String? labelText;
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
  final String? fieldText;

  TextFieldWidget({
    Key? key,
    this.focusNode,
    this.initialValue,
    this.star,
    this.label,
    this.hintText,
    this.labelText,
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
    this.fieldText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColor.primer,
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
      validator: validator == null ? null : validator,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: inputFormatters,
      style: Styles.texts,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIcon != null
            ? const BoxConstraints(
                maxWidth: 30,
                maxHeight: 25,
              )
            : null,
        prefixIconConstraints: prefixIcon != null
            ? const BoxConstraints(
                maxWidth: 30,
                maxHeight: 25,
              )
            : null,
        filled: true,
        fillColor: AppColor.white,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: prefixIcon != null || suffixIcon != null ? 10 : 10),
        border: enabled == false ? CommonStyle.borderGrey : CommonStyle.border,
        focusedBorder: enabled == false ? CommonStyle.borderGrey : CommonStyle.border,
        disabledBorder: enabled == false ? CommonStyle.borderGrey : CommonStyle.border,
        enabledBorder: enabled == false ? CommonStyle.borderGrey : CommonStyle.border,
        errorBorder: CommonStyle.borderRed,
        hintText: hintText,
        hintStyle: enabled == false ? Styles.labelGrey : Styles.labels,
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
                child: Text(label ?? "", style: enabled == false ? Styles.labelGrey : Styles.labels),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

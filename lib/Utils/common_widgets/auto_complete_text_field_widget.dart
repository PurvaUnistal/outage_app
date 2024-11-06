import 'package:flutter/material.dart';
import 'WidgetStyles/common_style.dart';
import 'res/app_color.dart';
import 'res/app_styles.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AutoCompleteTextFieldWidget extends StatelessWidget {
  final List<String> suggestions;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? enabled;
  final String? star;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function(String)? onSelected;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  TextEditingController? controller;

  AutoCompleteTextFieldWidget({
    super.key,
    required this.suggestions,
    this.suffixIcon,
    this.prefixIcon,
    this.star,
    this.enabled,
    this.label,
    this.hintText,
    this.keyboardType,
    this.onSelected,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return  Autocomplete(
      initialValue: TextEditingValue(text: controller?.text ?? ""),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        } else {
          return suggestions.where((word) {
            String startsFilter = word.toLowerCase().toString();
            return startsFilter.startsWith(textEditingValue.text.toLowerCase());
          });
        }
      },
      optionsViewBuilder:
          (context, Function(String) onSelectedOption, options) {
        return Material(
          elevation: 4,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                title: SubstringHighlight(
                  text: option.toString(),
                  term: controller!.text,
                  textStyleHighlight: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize:18 ),
                ),
                onTap: () {
                 onSelectedOption(option.toString());
                 this.onSelected!(option.toString());
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: options.length,
          ),
        );
      },
      onSelected: (selectedString) {
        print(selectedString);
      },
      fieldViewBuilder:
          (context, controller, focusNode, onEditingComplete) {
        return TextFormField(
          cursorColor: AppColor.primer,
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          validator: validator,
          style: Styles.texts,
          onChanged: onChanged,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorStyle: Styles.subStar,
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
      },
    );
  }


}

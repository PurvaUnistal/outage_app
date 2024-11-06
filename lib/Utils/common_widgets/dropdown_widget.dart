import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class DropdownWidget<T> extends StatelessWidget {
  final T? dropdownValue;
  final String hint;
  final String? label;
  final String? star;
  final void Function(T?)? onChanged;
  final List<T> items;

  const DropdownWidget({
    Key? key,
    required this.dropdownValue,
    required this.onChanged,
    required this.items,
    required this.hint,
    this.label,
    this.star,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
        hint: Text(hint, style: Styles.labels),
        style: Styles.texts,
        isExpanded: true,
        isDense: true,
        elevation: 16,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.white,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
          enabledBorder:CommonStyle.border,
          disabledBorder:CommonStyle.border,
          border: CommonStyle.border,
          focusedBorder: CommonStyle.border,
          errorBorder: CommonStyle.border,
          label: Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(star ?? "",  style:Styles.stars)),
                Flexible(child: Text(label  ?? "", style:Styles.labels),
                ),
              ],
            ),
          ),
        ),
        value: dropdownValue != null ? dropdownValue : null,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(value.toString(), style: Styles.texts,),
          );
        }).toList(),
        onChanged: onChanged
    );
  }
}

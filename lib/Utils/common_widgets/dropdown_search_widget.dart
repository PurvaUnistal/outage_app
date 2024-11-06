import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'WidgetStyles/common_style.dart';
import 'button_widget.dart';
import 'res/app_styles.dart';

class DropDownSearchWidget extends StatelessWidget {
  final List<dynamic> items;
  final ValueChanged<dynamic>? onChanged;
  final DropdownSearchItemAsString<dynamic>? itemAsString;
  final String hint;
  final String searchFieldHint;
  final String? searchFieldLabel;
  final String? label;
  final String? star;
  final dynamic dropdownValue;
  final DropdownSearchOnFind<String>? asyncItems;

  const DropDownSearchWidget({
    super.key,
    required this.items,
    this.onChanged,
    required this.itemAsString,
    required this.hint,
    required this.searchFieldHint,
    required this.searchFieldLabel,
    required this.star,
    required this.label,
    this.dropdownValue,
    this.asyncItems,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.054,
      child: DropdownSearch<dynamic>(
        items:  items,
        enabled : true,
      /*  clearButtonProps: ClearButtonProps(
          isVisible: true,
            icon: CircleAvatar(child: Icon(Icons.close_rounded,color: AppColor.white,),
              backgroundColor: AppColor.red,

            )),*/
        itemAsString: itemAsString,
        onChanged: onChanged,
        selectedItem: dropdownValue,
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration:InputDecoration(
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
        ),
        popupProps: PopupProps.modalBottomSheet(
            showSearchBox: true,
            modalBottomSheetProps: ModalBottomSheetProps(
              backgroundColor: AppColor.white,
              shape:RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(0))),
            ),
            searchFieldProps: TextFieldProps(
              decoration:InputDecoration(
                  filled: true,
                  fillColor: AppColor.white,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
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
                        Flexible(child: Text(searchFieldLabel  ?? "", style:Styles.labels),
                        ),
                      ],
                    ),
                  ),
                  hintText: searchFieldHint,
                  hintStyle: Styles.labels
              ),
            ),
            containerBuilder: (context, popupWidget) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Flexible(child: popupWidget),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: ButtonWidget(
                          onPressed: ()=>Navigator.pop(context),
                          text: "Close",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/row_widget.dart';

import 'res/app_styles.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  const TextWidget({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowWidget(
            widget1: Text(title, style: Styles.text),
            widget2: Text(subTitle, style: Styles.texts,)
        ),
        Divider(),
      ],
    );
  }
}

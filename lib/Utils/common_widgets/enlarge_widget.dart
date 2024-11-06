import 'dart:io';
import 'package:flutter/material.dart';

import 'res/app_styles.dart';

class EnlargeWidget extends StatelessWidget {
  final String text;
  final File photoPath;
  const EnlargeWidget({super.key, required this.text, required this.photoPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, textAlign: TextAlign.center, style: Styles.labels,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded),
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
        Container(
          width: 500,
          height: 500,
          child: photoPath.path.startsWith("http")
              ? Image.network(photoPath.path, fit: BoxFit.fill,)
              :Image.file(photoPath, fit: BoxFit.fill,),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'enlarge_widget.dart';
import 'res/app_color.dart';
import 'res/environment_config.dart';

class ImageWidget extends StatelessWidget {
  final File imgFile;
  final String title;
  final String? star;
  final void Function() onPressed;

  const ImageWidget(
      {super.key,
      required this.imgFile,
      this.star,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: imgFile.path.isNotEmpty
          ? Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Image.file(
                      imgFile,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width * 0.23,
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    Positioned(
                      child: Center(
                          child: Icon(
                        Icons.refresh,
                        color: EnvironmentConfig.of(context)!.primaryTheme,
                      )),
                    ),
                    Positioned(
                      top: -15,
                      right: -20,
                      child: TextButton(
                        child: Container(
                            color: EnvironmentConfig.of(context)!.primaryTheme,
                            child: Icon(
                              Icons.zoom_out_map,
                              color: AppColor.white,
                            )),
                        onPressed: () async {
                          await showBottomSheet(
                              context: context,
                              builder: (_) => EnlargeWidget(
                                    text: title,
                                    photoPath: imgFile,
                                  ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : CircleAvatar(
              backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
              child: Icon(
                Icons.photo_camera_back_outlined,
                color: AppColor.white,
                size: 18,
              )),
    );
  }
}

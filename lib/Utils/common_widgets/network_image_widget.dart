import 'dart:io';
import 'package:flutter/material.dart';

import 'enlarge_widget.dart';
import 'res/app_color.dart';
import 'res/app_string.dart';
import 'res/app_styles.dart';

class NetworkImageWidget extends StatelessWidget {
  final String title;
  final String? star;
  final String baseUrl;
  final File networkPath;
  final void Function() onPressed;
  const NetworkImageWidget({
    super.key,
    this.star,
    required this.baseUrl,
    required this.title,
    required this.onPressed,
    required this.networkPath,
  });
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(flex : 1,child: Text(star ??"",  style:Styles.subStar)),
            Flexible(flex : 6,child: Text(title  ?? "", style:Styles.subTitle),
            ),
          ],
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width *0.23,
            height:MediaQuery.of(context).size.height* 0.12,
            child: InkWell(
              onTap: onPressed,
              child: networkPath.path.isNotEmpty
                  ? Card(
                child: Stack(
                  children: <Widget>[
                    baseUrl.isNotEmpty && networkPath.path.startsWith("http")
                        ? Image.network(networkPath.path,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width *0.23,
                        height:MediaQuery.of(context).size.height* 0.12)
                        :  Image.file(networkPath,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width *0.23,
                      height:MediaQuery.of(context).size.height* 0.12,
                    ),
                    Positioned(
                      top: -15,
                      right: -20,
                      child: TextButton(
                        child: Container(
                            color: AppColor.primer,
                            child: Icon(Icons.zoom_out_map,color: AppColor.white,)),
                        onPressed: () async {
                          await showBottomSheet(
                              context: context,
                              builder: (_) => EnlargeWidget(text: title,photoPath: networkPath,));
                        },),
                    ),
                  ],

                ),
              )
                  :Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_back_outlined, color: AppColor.primer,size: 18,),
                    Text(AppString.photo,style: Styles.labels,),
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }
}

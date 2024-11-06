import 'package:flutter/material.dart';

import 'res/app_color.dart';
import 'res/app_styles.dart';


class ImagePopWidget extends StatelessWidget {
  final void Function() onTapGallery, onTapCamera;
  const ImagePopWidget(
      { Key? key,  required this.onTapGallery,  required this.onTapCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child:
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text('Choose One',textAlign: TextAlign.center, style:Styles.text),),
              ListTile(
                leading: Icon(Icons.photo_library,color: AppColor.primer),
                title: const Text('Gallery'),
                onTap: onTapGallery,
              ),
              Divider(color: AppColor.primer1,),
              ListTile(
                leading: Icon(Icons.photo_camera,color: AppColor.primer),
                title: const Text('Camera'),
                onTap: onTapCamera,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

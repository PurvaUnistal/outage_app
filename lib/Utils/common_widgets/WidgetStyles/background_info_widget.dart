import 'package:flutter/material.dart';

import '../res/app_color.dart';
import '../res/app_string.dart';
import '../res/app_styles.dart';

class BackgroundInfoWidget extends StatelessWidget {
  final Widget child;
  const BackgroundInfoWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColor.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: child,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(color: AppColor.primer),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text(
                          AppString.companyName,
                          textAlign: TextAlign.start,
                          style: Styles.rel,
                        )),
                        Flexible(
                            child: Text(
                              AppString.version,
                              textAlign: TextAlign.start,
                              style: Styles.rel,
                            )),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import '../res/app_asset.dart';
import '../res/app_config.dart';
import '../res/app_string.dart';
import '../res/app_styles.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetPath.pipeback),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
          ),
        ),
        child,
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                ),
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
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppString.version,
                          textAlign: TextAlign.start,
                          style: Styles.rel,
                        ),
                        AppConfig.instanceInit()?.loginData.user == null
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppConfig.instanceInit()
                                            ?.loginData
                                            .user!
                                            .name! ??
                                        "",
                                    textAlign: TextAlign.start,
                                    style: Styles.rel,
                                  ),
                                  Text(
                                    " (${AppConfig.instanceInit()?.loginData.user!.schema! ?? ""})",
                                    textAlign: TextAlign.start,
                                    style: Styles.rel,
                                  ),
                                ],
                              ),
                      ],
                    )),
                  ],
                ))),
      ],
    );
  }
}

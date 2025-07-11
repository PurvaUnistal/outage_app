import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/UserContext.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import '../res/app_string.dart';
import '../res/app_styles.dart';

class BackgroundInfoWidget extends StatelessWidget {
  final Widget child;

  const BackgroundInfoWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctx = UserContext.getUserContext();

    final themeColor =
        EnvironmentConfig.of(context)?.primaryTheme ??
        Theme.of(context).primaryColor;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child:
              ctx.user.name?.isNotEmpty == true
                  ? Text(
                "${ctx.user.name?.toUpperCase() ?? ""} "
                    "${ctx.schema.isEmpty ? "" :
                "(${ctx.schema.toUpperCase()}${ctx.gaId.isEmpty
                    ? ""
                    : (ctx.gridData.gridName != null && ctx.gridData.gridName!.isNotEmpty
                    ? " (${ctx.gridData.gridName!.toUpperCase()})"
                    : "")})"}",
                style: Styles.rel,
                overflow: TextOverflow.ellipsis,
              )

                  : Container(),
        ),
        Expanded(child: child),
        Container(
          width: double.infinity,
          color: themeColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.companyName, style: Styles.rel),
              Text(AppString.version, style: Styles.rel),
            ],
          ),
        ),
      ],
    );
  }
}

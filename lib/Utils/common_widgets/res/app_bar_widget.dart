import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';

import 'app_asset.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? boolLeading;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  const AppBarWidget({Key? key, this.title, this.leadingWidget, this.boolLeading, this.actions,}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: boolLeading ?? false,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
      centerTitle: true,
      leading: leadingWidget,
      title: Row(
        children: [
          /// Left icon
          Image.asset(
            AssetPath.smartgasnetLog,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.05,
            fit: BoxFit.contain,
          ),

          /// Spacer between left icon and title
          Expanded(
            child: Center(
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: Styles.appTitle,
              ),
            ),
          ),

          /// Right icon
          Image.asset(
            AssetPath.agclLogo,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.05,
            fit: BoxFit.contain,
          ),
        ],
      ),

      actions: actions ?? <Widget>[],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: CommonStyle.gradients,
        ),
      ),
    )
    ;
  }
}

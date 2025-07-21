import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';

import 'UserContext.dart';
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
    final ctx = UserContext.getUserContext();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: boolLeading ?? false,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
      centerTitle: true,
      titleSpacing: 0,
      leading: leadingWidget,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              // height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    ctx.user.projectLogo ?? "",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              // height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    ctx.user.smartLogo ?? "",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              title ?? "",
              style: Styles.appTitle,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
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

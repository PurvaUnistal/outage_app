import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/commonClass/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? boolLeading;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  const AppBarWidget({Key? key, this.title, this.leadingWidget, this.boolLeading, this.actions,}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

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
      title: Text(
        title ?? "",
        textAlign: TextAlign.center,
        style: Styles.appTitle,
      ),
      actions: actions ?? <Widget>[],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: CommonStyle.gradients,
        ),
      ),
    //  bottom: tabBar is PreferredSizeWidget ? tabBar : null,
    )
    ;
  }
}

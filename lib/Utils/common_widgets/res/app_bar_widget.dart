import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? boolLeading;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final Widget? tabBar;
  const AppBarWidget({Key? key, this.title, this.leadingWidget, this.boolLeading, this.actions, this.tabBar}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: boolLeading ?? false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.primer,
      ),
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      backgroundColor: AppColor.primer,
      elevation: 0,
      centerTitle: true,
      leading: leadingWidget,
      title: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Text(
          title ?? "",
          textAlign: TextAlign.center,
          style: Styles.appTitle,
        ),
      ),
      actions: actions ?? [],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColor.primer,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: tabBar ?? Container(),
      ),
    );
  }
}

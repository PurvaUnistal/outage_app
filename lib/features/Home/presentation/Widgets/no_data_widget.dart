import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("No access right",style: Styles.titleGreen,),
      ),
    );
  }
}

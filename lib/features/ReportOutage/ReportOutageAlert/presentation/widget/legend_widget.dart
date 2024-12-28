import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';

class LegendPopWidget extends StatelessWidget {
  final BuildContext mContext;
  const LegendPopWidget({super.key,
    required this.mContext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Dialog(
              backgroundColor:Colors.white70,
              insetPadding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.0),
                  Text("Legend", textAlign: TextAlign.center,),
                  SizedBox(height: 16.0),
                  _row(name: AppString.gasTfGis,path: AssetPath.tf),
                  _row(name: AppString.gasValveGIS,path: AssetPath.valve),
                  CommonStyle.widthSpace(context: mContext),
                  _row(name: AppString.gasRegulatorGIS,path: AssetPath.regulator),
                  _row(name: AppString.gasConsumerGIS,path: AssetPath.consumer),
                  CommonStyle.widthSpace(context: mContext),
                 /* _row(name: AppString.gasTeeGIS,path: AssetPath.tee),
                  _row(name: AppString.gasElbowGIS,path: AssetPath.elbow),
                  _row(name: AppString.gasCouplerGIS,path: AssetPath.coupler),
                  _row(name: AppString.gasReducerGIS,path: AssetPath.reduce),
                  _row(name: AppString.gasEndCapGIS,path: AssetPath.endcap),*/
                  SizedBox(height: 16.0),
                  _closeBtn(),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          );
  }
  Widget _row({required String path, required String name}){
    return Column(
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
          child: Row(
            children: [
              Image.asset(path, width: 30, height: 30,),
              CommonStyle.widthSpace(context: mContext),
              Text(name)
            ],
          ),
        ),
      ],
    );
  }
  Widget _closeBtn(){
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        width: MediaQuery.of(mContext).size.width * 0.4,
        child: ButtonWidget(onPressed: (){
          Navigator.pop(mContext, true);
        }, text: "Close"),
      ),
    );
  }

}


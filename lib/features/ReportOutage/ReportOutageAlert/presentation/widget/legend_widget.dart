import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

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
                 crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.0),
                  Center(child: Text("Legend", textAlign: TextAlign.center,style: Styles.text,)),
                  SizedBox(height: 16.0),
                  Divider(color: EnvironmentConfig.of(context)!.secondaryTheme,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Marker Icon", textAlign: TextAlign.start,style: Styles.labelGrey,),
                        Text("Pipeline", textAlign: TextAlign.start,style: Styles.labelGrey,),
                      ],
                    ),
                  ),
                  _row(name: AppString.gasTfGis,path: AssetPath.tf, color:Colors.yellow.shade900,context:mContext ),
                  _row(name: AppString.gasValveGIS,path: AssetPath.valve,color: Colors.deepOrange,context:mContext),
                  CommonStyle.widthSpace(context: mContext),
                  _row(name: AppString.gasRegulatorGIS,path: AssetPath.regulator,color: Colors.yellowAccent.shade700,context:mContext),
                  _row(name: AppString.gasConsumerGIS,path: AssetPath.consumer,color: Colors.green,context:mContext),
                  CommonStyle.widthSpace(context: mContext),
                  Divider(color: EnvironmentConfig.of(context)!.secondaryTheme,),

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
  Widget _row({required String path, required String name,required Color color, required BuildContext context}){
    return Column(
      children: [
        Divider(color: EnvironmentConfig.of(context)!.secondaryTheme,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
          child: Row(
            children: [
              Image.asset(path, width: 30, height: 30,),
              CommonStyle.widthSpace(context: mContext),
              Text(name),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 3,               // Thickness of the line
                color: color,     // Color of the line
              // Optional padding around the line
              )
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


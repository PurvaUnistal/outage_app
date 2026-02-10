import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

class LegendPopWidget extends StatelessWidget {
  final BuildContext context;
  const LegendPopWidget({super.key,
    required this.context,
  });
  @override
  Widget build(BuildContext context) {
    final diaColors = AppConfig.instanceInit()?.diaColors;
    // Generate dynamic legend lines based on diaColors
    final diaLegendLines = diaColors?.entries.map((entry) {
      final parts = entry.key.split('-');
      return _line(
        color: Color(int.parse(entry.value)),
        label: (parts.length == 2)
            ? "${parts[0]} To ${parts[1]} (Dia)"
            : entry.key,
      );
    }).toList() ?? [];
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
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text("Markers")),
                              _row(name: AppString.gasTfGis, path: AssetPath.tf),
                              _row(name: AppString.gasValveGIS, path: AssetPath.valve),
                              _row(name: AppString.gasRegulatorGIS, path: AssetPath.regulator),
                              _rowDot(color: Colors.deepOrangeAccent, name: "Commercial"),
                              _rowDot(color: Colors.yellowAccent, name: "Domestic"),
                              _rowDot(color: Colors.blue.shade800, name: "Industrial"),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                       color: EnvironmentConfig.of(context)!.secondaryTheme,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        Expanded(
                          // child: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Center(child: Text("Pipeline")),
                          //     _line(color: Color(0xFFFF0000), label: "0 To 50 (Dia)"),
                          //     _line(color: Color(0xFFFFC0CB), label: "63 To 90 (Dia)"),
                          //     _line(color: Color(0xFF00FFFF), label: "100 To 140 (Dia)"),
                          //     _line(color: Color(0xFF90EE90), label: "150 To 200 (Dia)"),
                          //   ],
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: diaLegendLines,
                          ),
                        ),
                      ],
                    ),
                  ),
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
        Divider(color: EnvironmentConfig.of(context)!.secondaryTheme,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
          child: Row(
            children: [
              Image.asset(path, width: 20, height: 20,),
              CommonStyle.widthSpace(context: context),
              Text(name),
            ],
          ),
        ),
      ],
    );
  }
 Widget _line({required Color color, required String label}){
  return Row(
    children: [
      Transform.rotate(
        angle: -0.8,
        child: Container(
          width: 20,
          height: 4,
          color: color,
        ),
      ),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 14)),
    ],
  );
 }
  Widget _rowDot({required String name,required Color color,}){
    return Column(
      children: [
        Divider(color: EnvironmentConfig.of(context)!.secondaryTheme,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Icon(Icons.circle, color: color,size: 12,),
              ),
              Text(name),
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
        width: MediaQuery.of(context).size.width * 0.4,
        child: ButtonWidget(onPressed: (){
          Navigator.pop(context, true);
        }, text: "Close"),
      ),
    );
  }

}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Report/CreateAlertForm/presentation/create_alert_form_page.dart';
import 'package:outage_app/features/Report/ReportOutageAlert/domain/model/PipelineModel.dart';

class AlertDialogDetailsWidgetWidget extends StatelessWidget {
  final BuildContext mContext;
  final dynamic pipelineData;

  const AlertDialogDetailsWidgetWidget({
    super.key,
    required this.mContext,
    this.pipelineData,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = EnvironmentConfig.of(context)?.primaryTheme;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.8,
      child: SingleChildScrollView(
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          titlePadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pipelineData != null) ...[
                if(pipelineData.bpName != null && pipelineData.bpName != "" )...[
                  buildInfoRow("BP Name", pipelineData.bpName ?? "NA"),
                  buildInfoRow("Latitude", pipelineData.latitude ?? "NA"),
                  buildInfoRow("Longitude", pipelineData.longitude ?? "NA"),
                  buildInfoRow("Dia", pipelineData.nominaldia ?? "NA"),
                  (pipelineData.imagePath != null && pipelineData.imagePath.isNotEmpty && pipelineData.housePhoto != null)
                      ? IconButton(
                      icon: Icon(Icons.image,size: 23,color: EnvironmentConfig.of(context)?.primaryTheme,),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return Material(
                              color: Colors.black.withOpacity(0.5),
                              child: SafeArea(
                                child: Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        "House Image",
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            pipelineData.imagePath,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      CupertinoButton.filled(
                                        child: Text("Close"),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );


                      })
                      : Container(),
                ]else...[
                  // buildInfoRow("Name", pipelineData.name ?? ""),
                  buildInfoRow("Grid", pipelineData.location ?? "NA"),
                  buildInfoRow("District", pipelineData.district ?? "NA"),
                  buildInfoRow("Dia", pipelineData.nominaldia ?? "NA"),
                ],
                const SizedBox(height: 8),
              ],

              Flexible(
                child: ButtonWidget(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(mContext),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, dynamic subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              subtitle?.toString() ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

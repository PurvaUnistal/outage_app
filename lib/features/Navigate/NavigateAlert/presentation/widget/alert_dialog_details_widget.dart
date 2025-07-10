import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

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
                if (pipelineData.bpName != null &&
                    pipelineData.bpName != "") ...[
                  buildInfoRow("Customer Name", pipelineData.bpName ?? "NA"),
                  buildInfoRow("Latitude", pipelineData.latitude ?? "NA"),
                  buildInfoRow("Longitude", pipelineData.longitude ?? "NA"),
                  (pipelineData.imagePath != null &&
                          pipelineData.imagePath.isNotEmpty &&
                          pipelineData.housePhoto != null &&
                          pipelineData.housePhoto.isNotEmpty)
                      ? InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return Material(
                                color: Colors.black.withOpacity(0.5),
                                child: SafeArea(
                                  child: Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.75,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            "House Image",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                pipelineData.imagePath,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return const Center(
                                                    child: Text(
                                                      "Image not available",
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          CupertinoButton.filled(
                                            child: const Text("Close"),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Text(
                              "House Photo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.image,
                              size: 24,
                              color:
                                  EnvironmentConfig.of(context)?.primaryTheme,
                            ),
                          ],
                        ),
                      )
                      : Container(),
                ] else ...[
                  buildInfoRow("Grid", pipelineData.location ?? "NA"),
                  buildInfoRow("District", pipelineData.district ?? "NA"),
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

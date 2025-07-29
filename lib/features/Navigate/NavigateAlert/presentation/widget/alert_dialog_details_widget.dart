import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';

class AlertDialogDetailsWidgetWidget extends StatelessWidget {
  final dynamic pipelineData;
  final String? filterByKey;

  const AlertDialogDetailsWidgetWidget({
    super.key,
    this.filterByKey,
    this.pipelineData,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = EnvironmentConfig.of(context)?.primaryTheme;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3.8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pipelineData != null) ...[
                        if (pipelineData.bpName != null && pipelineData.bpName != "") ...[
                          if (filterByKey != null && filterByKey!.isNotEmpty)
                            Text(filterByKey ?? "NA"),
                          buildInfoRow("Customer Name", pipelineData.bpName),
                          if (pipelineData.imagePath != null &&
                              pipelineData.imagePath.isNotEmpty &&
                              pipelineData.housePhoto != null &&
                              pipelineData.housePhoto.isNotEmpty)
                            InkWell(
                              onTap: () => showHouseImage(context, pipelineData.imagePath),
                              child: Row(
                                children: [
                                  const Text("House Photo"),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Image.network(
                                      pipelineData.imagePath,width: 50,height: 50,
                                      fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Center(
                                        child: Icon(Icons.image, size: 24, color: textColor),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                        ] else ...[
                          if (filterByKey != null && filterByKey!.isNotEmpty)
                            Text(filterByKey ?? "NA"),
                          buildInfoRow("Grid", pipelineData.location),
                          buildInfoRow("District", pipelineData.district),
                          buildInfoRow("Nominal Dia", "${pipelineData.nominaldia}mm"),
                        ],
                        const SizedBox(height: 8),
                        const Divider(),
                      ],
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  "Map GPS navigation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ButtonWidget(
                  text: "Navigate",
                  icon: Icons.alt_route,
                  onPressed: () {
                    double lat = double.parse(pipelineData.latitude);
                    double lng = double.parse(pipelineData.longitude);
                    LatLng toPoints = LatLng(lat, lng);
                    BlocProvider.of<NavigateAlertBloc>(
                      context,
                    ).add(SelectGoogleRouteDirEvent(context: context,toLatLng: toPoints));
                  },
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
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              subtitle?.toString() ?? 'NA',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void showHouseImage(BuildContext context, String imagePath) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Material(
          color: Colors.black.withOpacity(0.5),
          child: SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.75,
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
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text("Image not available"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton.filled(
                      child: const Text("Close"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

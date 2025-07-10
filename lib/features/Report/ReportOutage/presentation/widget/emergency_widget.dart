import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_bloc.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_event.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_state.dart';

class EmergencyWidget extends StatelessWidget {
  const EmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncidentReportBloc, IncidentReportState>(
      builder: (context, state) {
        if (state is FetchIncidentReportDataState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              "🚨 Emergency Alert",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.redAccent,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Please select the type of emergency:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                AutoCompleteTextFieldWidget(
                  label: AppString.emergency,
                  hintText: AppString.emergency,
                  controller: state.emergencyController,
                  suggestions: state.listOfEmergencyId,
                  onSelected: (val) {
                    BlocProvider.of<IncidentReportBloc>(context)
                        .add(SelectSearchEmergencyEvent(searchEmergency: val));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.redAccent,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //   ),
              //   onPressed: () {
              //     // Do something on submit
              //   },
              //   child: const Text(
              //     "Submit",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

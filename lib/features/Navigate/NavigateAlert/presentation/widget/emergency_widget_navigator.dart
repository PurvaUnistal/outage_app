import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/auto_complete_text_field_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_bloc.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_event.dart';
import 'package:outage_app/features/Navigate/NavigateAlert/domain/navigate_alert_state.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_bloc.dart';

class EmergencyWidgetNavigator extends StatelessWidget {
  const EmergencyWidgetNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<NavigateAlertBloc, NavigateAlertState>(
      builder: (context, state) {
        if (state is FetchNavigateAlertDataState) {
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
                    BlocProvider.of<NavigateAlertBloc>(context)
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
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

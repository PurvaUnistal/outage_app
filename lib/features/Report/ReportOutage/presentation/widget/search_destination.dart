import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/button_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_bloc.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_event.dart';
import 'package:outage_app/features/Report/ReportOutage/domain/bloc/incident_report_state.dart';

class SearchDestination extends StatelessWidget {
  const SearchDestination({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncidentReportBloc, IncidentReportState>(
      builder: (context, state) {
        if (state is FetchIncidentReportDataState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CommonStyle.vertical(context: context),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Places',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                              () => BlocProvider.of<IncidentReportBloc>(
                            context,
                          ).add(SearchHideShowEvent());
                        },
                        icon: Icon(Icons.cancel_outlined, color: Colors.red),
                      ),
                    ],
                  ),

                  TextFieldWidget(
                    label: 'Current Location',
                    hintText: 'Choose starting point',
                    controller: state.startAddressController,
                    prefixIcon: Icon(
                      Icons.looks_one,
                      color: EnvironmentConfig.of(context)!.primaryTheme,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: EnvironmentConfig.of(context)!.primaryTheme,
                      ),
                      onPressed:
                          () => BlocProvider.of<IncidentReportBloc>(
                            context,
                          ).add(UpdateStartAddress()),
                    ),
                  ),
                  CommonStyle.vertical(context: context),
                  TextFieldWidget(
                    label: 'Destination',
                    hintText: 'Choose destination',
                    controller: state.destinationAddressController,
                    prefixIcon: Icon(
                      Icons.looks_two,
                      color: EnvironmentConfig.of(context)!.primaryTheme,
                    ),
                    onChanged: (val) => BlocProvider.of<IncidentReportBloc>(
                          context,
                        ).add(UpdateDestinationAddress(val)),
                  ),

                  CommonStyle.vertical(context: context),

                  Visibility(
                    visible: state.placeDistance == '' ? false : true,
                    child: Text(
                      'DISTANCE: ${state.placeDistance} km',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ButtonWidget(
                    text: "Show Route",
                    onPressed: () {
                      BlocProvider.of<IncidentReportBloc>(
                        context,
                      ).add(ShowRouteButtonEvent(context: context));
                    },
                  ),
                  CommonStyle.vertical(context: context),
                  CommonStyle.vertical(context: context),
                ],
              ),
            ),
          );
        } else {
          return Center(child: SpinLoader());
        }
      },
    );
  }
}

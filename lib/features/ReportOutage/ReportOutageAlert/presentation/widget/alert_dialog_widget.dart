import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/row_widget.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/presentation/create_alert_form_page.dart';

class AlertDialogTwoBtnWidget extends StatelessWidget {

  const AlertDialogTwoBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 250,
      child: Column(
        children: [
          Text("Do you want to create Alert?"),
          RowWidget(
              widget1: ButtonWidget(onPressed: (){}, text: "Canal"),
              widget2: ButtonWidget(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateAlertFormView()),
                );
              }, text: "Create"))
        ],
      ),
    );
  }
}

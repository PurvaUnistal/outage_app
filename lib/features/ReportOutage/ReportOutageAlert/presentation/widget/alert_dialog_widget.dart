import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_widget.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/presentation/create_alert_form_page.dart';

class AlertDialogTwoBtnWidget extends StatelessWidget {

  const AlertDialogTwoBtnWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Do you want to create alert ?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              ButtonWidget(
                 text : "No",
                  onPressed: ()=> Navigator.pop(context),),
              SizedBox(width: 12,),
              ButtonWidget(
                  text : "Yes",
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (buildContext) => const CreateAlertFormView()),
                    );
                  },),
            ],
          ),
        ],
      ),
    );
  }
}

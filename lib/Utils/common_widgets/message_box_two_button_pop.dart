import 'package:flutter/material.dart';

import 'res/app_color.dart';
import 'res/app_styles.dart';


class MessageBoxTwoButtonPopWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final String okButtonText;
  final VoidCallback onPressed;

  const MessageBoxTwoButtonPopWidget({ required this.message, this.subMessage, required this.onPressed, required this.okButtonText});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Wrap(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
                    child: Column(
                      children: [
                        _vertical(context: context),
                        Text(
                          "Alert !",textAlign: TextAlign.center,style: Styles.stars,
                        ),
                        _vertical(context: context),
                        Text(message,textAlign: TextAlign.center,),
                        Text(subMessage?? "",),
                        Divider(color: AppColor.grey,),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed:  () {
                                  Navigator.pop(context);
                                }, child: Text("Cancel",
                              ),
                              ),),
                            Expanded(
                              child: TextButton(
                                onPressed:  onPressed,
                                child: Text(okButtonText,
                                ),
                              ),

                            )

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _vertical({required BuildContext context}){
    return  SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

}

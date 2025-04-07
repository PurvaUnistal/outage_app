import 'package:flutter/material.dart';


class PopTwoBtnWidget extends StatelessWidget {
  final String? message;
  final String? okButtonText;
  final VoidCallback? onPressed;

  const PopTwoBtnWidget({ this.message,  this.onPressed, this.okButtonText});

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
                  _closeButton(context: context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Text(message!),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[350],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed:  () {
                              Navigator.pop(context);
                            }, child: Text("Cancel", style: TextStyle(color: Colors.green.shade800),),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: 1.0,
                          color: Colors.grey[350],
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed:  onPressed,
                            child: Text(okButtonText ?? "OK",style: TextStyle(color: Colors.green.shade800),),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _closeButton({ required BuildContext context}) {
    return Padding(
      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.05,),
      child: Text("Alert !", style: TextStyle(color: Colors.red),),
    );
  }
}
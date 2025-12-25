import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:outage_app/Utils/common_widgets/Routes/routes.dart';
import 'package:outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/bloc_multi_provider.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/res/secrets.dart';
import 'package:outage_app/Utils/common_widgets/res/singleton.dart';
import 'package:uuid/uuid.dart';

import 'Utils/common_widgets/res/UserContext.dart';

class RootApp extends StatefulWidget {
  final Client client;

  const RootApp({required this.client});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Singleton.instanceInit()?.context = context;
    AppConfig.instanceInit()!.setClient(client: widget.client);
    return multiBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: EnvironmentConfig.of(context)!.primaryTheme,
          hintColor: EnvironmentConfig.of(context)!.primaryTheme,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: EnvironmentConfig.of(context)!.primaryTheme,
          ),
        ),
       //  home: PollScreen(),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}



class PollAnswersModel {
  dynamic id;
  dynamic answer;
  dynamic percentage;
  dynamic myAnswer;
  dynamic remaining;
  bool isSelected;
  bool isLoader;

  PollAnswersModel({
    this.id,
    this.answer,
    this.myAnswer,
    this.percentage,
    this.remaining,
    this.isSelected = false,
    this.isLoader = false
  });

  factory PollAnswersModel.fromJson(Map<String, dynamic> json) {
    return PollAnswersModel(
      id: json['answer_id']?.toString() ?? "",
      answer: json['answer'] ?? "",
      percentage: int.tryParse(json['percent']?.toString() ?? "0") ?? 0,
      myAnswer: int.tryParse(json['my_answer']?.toString() ?? "0") ?? 0,
      remaining: json['remaining'] ?? "",
      isSelected: json['my_answer'] != null
          ? json['my_answer'].toString() == "1"
          ? true
          : false
          : false,
      isLoader: false,
    );
  }
}

List<PollAnswersModel> pollAnswerListResponse(Map<String, dynamic> json) {
  final response = json['response'];
  String remaining =  response['remaining'] != null ? response['remaining'].toString() : "0";
  return List<PollAnswersModel>.from(response['poll'].map((x) {
     x['percent'] =  24;
     return PollAnswersModel.fromJson(x);
  }));

}

class PollScreen extends StatelessWidget {
  PollScreen({super.key});
  final Map<String, dynamic> jsonData = {
    "status": 200,
    "response": {
      "message": "Answer submitted successfully.",
      "poll": [
        {
          "answer_id": "44",
          "answer": "Real-Time Threat Detection",
          "percent": 29,
          "total_votes": 15,
          "my_answer": 0
        },
        {
          "answer_id": "45",
          "answer": "AI-powered EDR",
          "percent": 33,
          "total_votes": 17,
          "my_answer": 0
        },
        {
          "answer_id": "46",
          "answer": "Auto-Respond to Threats",
          "percent": 27,
          "total_votes": 14,
          "my_answer": 0
        },
        {
          "answer_id": "47",
          "answer": "Integrate & Scale Easily",
          "percent": 12,
          "total_votes": 6,
          "my_answer": 1
        }
      ],
      "remaining": 2
    }
  };

  @override
  Widget build(BuildContext context) {
    final pollList = pollAnswerListResponse(jsonData);

    return Scaffold(
      body: ListView.builder(
        itemCount: pollList.length,
        itemBuilder: (context, index) {
          final poll = pollList[index];
          return ListTile(
            title: Text(poll.answer),
            subtitle: Text("Remaining: ${poll.percentage}"),
          );
        },
      ),
    );
  }
}




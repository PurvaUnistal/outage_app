import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';

import 'voideRecord/audio_player.dart';
import 'voideRecord/audio_recorder.dart';

class VoideRecord extends StatefulWidget {
  String audioPath;
  VoideRecord({super.key, required this.audioPath});

  @override
  State<VoideRecord> createState() => _VoideRecordState();
}

class _VoideRecordState extends State<VoideRecord> {
  bool showPlayer = false;

  @override
  void initState() {
    _audioPath();
    super.initState();
  }

  _audioPath(){
    if(widget.audioPath.isNotEmpty){
      showPlayer = true;
    }else{
      showPlayer = false;
    }
  }



  @override
  Widget build(BuildContext context) {
    print("audioPath-->${widget.audioPath}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.audioPath.isNotEmpty && showPlayer
          ? _showAudio()
          : Column(
              children: [
                showPlayer == false
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () async {
                              if (widget.audioPath.isNotEmpty) {
                                if (widget.audioPath.toString().isNotEmpty) {
                                  final file =
                                      File(widget.audioPath.toString());
                                  if (await file.exists()) {
                                    file.delete();
                                  }
                                }
                              }
                              Navigator.pop(
                                  !context.mounted ? context : context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: EnvironmentConfig.of(context)!.primaryTheme,
                            )),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: showPlayer
                      ? _showAudio()
                      : Recorder(
                          onStop: (path) {
                            if (kDebugMode)
                              print('Recorded file path: $path');
                            setState(() {
                              print("rerord-->${path}");
                              widget.audioPath = path;
                              showPlayer = true;
                            });
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _showAudio(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 25),
          child: AudioPlayer(
            source: widget.audioPath,
            onDelete: () {
              print("audioPath");
              setState(() => showPlayer = false);
            },
          ),
        ),
        showPlayer
            ? _actionButton()
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () async {
              if (widget.audioPath != null) {
                if (widget.audioPath.toString().isNotEmpty) {
                  final file = File(widget.audioPath.toString());
                  if (await file.exists()) {
                    file.delete();
                  }
                }
              }
              Navigator.pop(!context.mounted ? context : context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColor.black),
            )),
        IconButton(
            onPressed: () {
              Navigator.pop(context, widget.audioPath.toString());
            },
            icon: Icon(Icons.done, color: AppColor.green)),
      ],
    );
  }
}

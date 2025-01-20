import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/text_widget.dart';

import 'voideRecord/audio_player.dart';
import 'voideRecord/audio_recorder.dart';

class VoideRecord extends StatefulWidget {
  const VoideRecord({super.key});

  @override
  State<VoideRecord> createState() => _VoideRecordState();
}

class _VoideRecordState extends State<VoideRecord> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          showPlayer == false
              ? Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () async {
                        if (audioPath != null) {
                          if (audioPath.toString().isNotEmpty) {
                            final file = File(audioPath.toString());
                            if (await file.exists()) {
                              file.delete();
                            }
                          }
                        }
                        Navigator.pop(!context.mounted ? context : context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColor.primer,
                      )),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Center(
              child: showPlayer
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: AudioPlayer(
                        source: audioPath!,
                        onDelete: () {
                          setState(() => showPlayer = false);
                        },
                      ),
                    )
                  : Recorder(
                      onStop: (path) {
                        if (kDebugMode) print('Recorded file path: $path');
                        setState(() {
                          audioPath = path;
                          showPlayer = true;
                        });
                      },
                    ),
            ),
          ),
          showPlayer ? _actionButton() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () async {
              if (audioPath != null) {
                if (audioPath.toString().isNotEmpty) {
                  final file = File(audioPath.toString());
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
              Navigator.pop(context, audioPath.toString());
            },
            icon: Icon(Icons.done, color: AppColor.green)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordWidget extends StatefulWidget {
  @override
  _VoiceRecordWidgetState createState() => _VoiceRecordWidgetState();
}

class _VoiceRecordWidgetState extends State<VoiceRecordWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await _requestPermissions();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    _recordedFilePath = 'audio_example.aac';
    await _recorder.startRecorder(
        toFile: _recordedFilePath, codec: Codec.aacADTS);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _startPlaying() async {
    if (_recordedFilePath != null) {
      await _player.startPlayer(
          fromURI: _recordedFilePath, codec: Codec.aacADTS);
      print("_recordedFilePath---->${_recordedFilePath}");
      setState(() {
        _isPlaying = true;
      });

      _player.onProgress!.listen((event) {
        if (event != null && event.position >= event.duration) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }

  Future<void> _stopPlaying() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: _rowText(
                  text: _isRecording ? 'Stop Recording' : 'Start Recording',
                  icon: _isRecording
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_outlined),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPlaying ? _stopPlaying : _startPlaying,
              child: _rowText(
                  text: _isPlaying ? 'Stop Playback' : 'Play Recording',
                  icon: _isPlaying
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowText({required String text, required IconData icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primer,
              decoration: TextDecoration.none,
            )),
        Icon(
          icon,
          color: AppColor.primer,
        )
      ],
    );
  }
}

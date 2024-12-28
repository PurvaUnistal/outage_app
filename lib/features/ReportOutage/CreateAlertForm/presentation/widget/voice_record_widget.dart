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
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _player.openPlayer();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    _audioPath = "audio_${DateTime.now().millisecondsSinceEpoch}.aac";
    await _recorder.startRecorder(toFile: _audioPath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);
  }

  Future<void> _playAudio() async {
    if (_audioPath?.isEmpty ?? true) return;
    try {
      await _player.startPlayer(
        fromURI: _audioPath,
        codec: Codec.aacADTS,
      );
      setState(() => _isPlaying = true);
      /*  _player.startPlayerCompleted.listen((_) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });*/
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _stopAudio() async {
    await _player.stopPlayer();
    setState(() => _isPlaying = false);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  icon: _isRecording
                      ? Icon(Icons.stop_circle_outlined)
                      : Icon(
                          Icons.play_circle_outline_outlined,
                          color: AppColor.primer,
                        )),
              Text(
                _isRecording ? "Stop Recording" : "Start Recording",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primer,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          _isRecording == false ? Container() : Row(
            children: [
              IconButton(
                onPressed: _isPlaying ? _stopAudio : _playAudio,
                icon: Icon(Icons.play_circle_outline_outlined, color: AppColor.primer,)
              ),
              Text(
                _isPlaying ? "Stop Audio" : "Play Audio",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primer,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

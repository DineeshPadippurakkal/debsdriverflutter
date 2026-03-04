import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:audioplayers/audioplayers.dart';

class DriverTaskHandler extends TaskHandler {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/new_order.mp3'));
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _player.stop();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}
}

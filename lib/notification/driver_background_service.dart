import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class DriverBackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        initialNotificationTitle: "Driver Alert Service",
        initialNotificationContent: "Running...",
      ),
      iosConfiguration: IosConfiguration(),
    );

    await service.startService();

    log("🚀 Background Service Initialized");
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    log("🔥 DriverBackgroundService STARTED");

    final AudioPlayer player = AudioPlayer();
    StreamSubscription? completeSubscription;

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      log("📢 Running as Foreground Service");

      // 🔊 PLAY SOUND
      service.on('playSound').listen((event) async {
        service.on('playSound').listen((event) async {
          log("🔊 STARTING REPEAT SOUND");

          await player.stop();

          await player.setReleaseMode(ReleaseMode.loop);

          await player.play(
            AssetSource('sounds/notification_sound.wav'),
            volume: 1.0,
          );
        });
      });

      // 🛑 STOP SOUND
      service.on('stopSound').listen((event) async {
        log("🛑 stopSound event received");

        completeSubscription?.cancel();
        await player.stop();
      });

      // 💓 HEARTBEAT (Check if service alive)
      Timer.periodic(const Duration(seconds: 15), (timer) {
        log("💓 Service alive at ${DateTime.now()}");

        service.setForegroundNotificationInfo(
          title: "Driver Alert Active",
          content: "Alive: ${DateTime.now().second}",
        );
      });
    }
  }

  static Future<void> startAlert() async {
    final service = FlutterBackgroundService();
    bool isRunning = await service.isRunning();

    log("📊 Service running: $isRunning");

    if (!isRunning) {
      await service.startService();
      log("🚀 Service restarted");
    }

    service.invoke("playSound");
  }

  static Future<void> stopAlert() async {
    final service = FlutterBackgroundService();
    service.invoke("stopSound");
  }
}

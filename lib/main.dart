import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:debs_driver_app/Utils/sqldata.dart';
import 'package:debs_driver_app/homescreen.dart';
import 'package:debs_driver_app/provider/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensures Flutter is ready before we run platform-specific code
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  await DBHelper.instance.database; // safe
await _checkAndRequestLocationPermission();
await initializeService();

  log("started");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // statusBarColor: Colors.black, // Notification bar color
    statusBarIconBrightness: Brightness.dark, // Icons color (light = white)
  ));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
    ),
  ], child: const MyApp()));

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e7cb9d5b-e1b0-4c51-ad97-3658289aeb5e");
  OneSignal.Notifications.requestPermission(true);
  log(OneSignal.User.pushSubscription.id.toString());
}




Future<void> _checkAndRequestLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    log('❌ Location permissions are permanently denied.');
    return;
  }

  log('✅ Location permission granted');
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
        initialNotificationTitle: "Driver Location Service",
   initialNotificationContent:  "Tracking location every 15 seconds",
  //  foregroundServiceTypes: AndroidForegroundType.location, //  ADD THIS
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
    await Firebase.initializeApp();

  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // Runs every 15 seconds
  Timer.periodic(const Duration(seconds: 15), (timer) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref("drivers-location/26");

    await ref.set({
      "latitude": position.latitude,
      "longitude": position.longitude,
      "timestamp": DateTime.now().toIso8601String(),
    });

    log("📍 Location Updated: ${position.latitude}, ${position.longitude}");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    OneSignal.Notifications.addForegroundWillDisplayListener((state) {
      debugPrint("Message title: ${state.notification.title}");
      final provider = context.read<NotificationProvider>();
      provider.messagerecieved(true);
      state.notification.display();
    });
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loginDataString = prefs.getString('logindata');

    if (loginDataString == null) return false;

    final Map<String, dynamic> loginData = jsonDecode(loginDataString);

    return loginData.toString().isNotEmpty;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'allow driver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const Homescreen(); // logged in
          } else {
            return const LoginScreen(); // not logged in
          }
        },
      ),
    );
  }
}

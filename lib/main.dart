import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:debs_driver_app/notification/DriverAlertScreen.dart';
import 'package:intl/intl.dart';

import 'notification/driver_background_service.dart';
import 'package:uuid/uuid.dart';
import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/Utils/sqldata.dart';
import 'package:debs_driver_app/home/homescreen.dart';
import 'package:debs_driver_app/provider/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    settings: settings,
  );
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'c4da3990-6a47-4229-bfa6-7228a5d04f59',
    'Alert',
    description: 'Important alerts',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalNotifications();
  await createNotificationChannel();
  await DriverBackgroundService.initializeService();

  WebViewPlatform.instance = AndroidWebViewPlatform();

  await Firebase.initializeApp();
  await DBHelper.instance.database;
  await _checkAndRequestLocationPermission();
  await initializeService();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e7cb9d5b-e1b0-4c51-ad97-3658289aeb5e");
  await OneSignal.Notifications.requestPermission(true);

  OneSignal.User.pushSubscription.addObserver((state) {
    final id = state.current.id;
    if (id != null) {
      log("🔥 OneSignal Player ID: $id");
    }
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      initialNotificationContent: "Tracking location every 15 seconds",
      //  foregroundServiceTypes: AndroidForegroundType.location, //  ADD THIS
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await Firebase.initializeApp();
  final database = FirebaseDatabase.instance;

  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  final prefs = await SharedPreferences.getInstance();
  final driverID = prefs.getInt('driverID');

  // Runs every 15 seconds
  Timer.periodic(const Duration(seconds: 15), (timer) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final uniqueID = const Uuid().v4();
     final createdAt =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    DatabaseReference ref =
        FirebaseDatabase.instance.ref("drivers-location/") .child(driverID.toString())
        .child(uniqueID);

    await ref.set({
      "latitude": position.latitude,
      "longitude": position.longitude,
      "createdAt": createdAt,
    });

    log("📍 Location Updated: ${position.latitude}, ${position.longitude}");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // 👇 allows language change from anywhere
  static void setLocale(BuildContext context, Locale locale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();

  static void showLanguageDialog(BuildContext context, {bool force = false}) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?._showLanguageDialogIfNeeded(
      Navigator.of(context, rootNavigator: true).context,
      force: force,
    );
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  @override
  void initState() {
    super.initState();

    _loadSavedLanguage();

    // 🔔 Foreground Notification
    // OneSignal.Notifications.addForegroundWillDisplayListener((state) {
    //   debugPrint("Message title: ${state.notification.title}");

    //   final provider = context.read<NotificationProvider>();
    //   provider.messagerecieved(true);

    //   // 🔊 Start looping alert sound
    //   final service = FlutterBackgroundService();
    //   service.invoke("playSound");

    //   state.notification.display();
    // });

    // // 🔔 When notification clicked (background case)
    // OneSignal.Notifications.addClickListener((event) {
    //   final service = FlutterBackgroundService();
    //   service.invoke("playSound");
    // });

    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _showLanguageDialogIfNeeded(context);
    //   });

    // OneSignal.Notifications.addForegroundWillDisplayListener((state) {
    //   DriverBackgroundService.startAlert();
    //   state.notification.display();
    // });

    // OneSignal.Notifications.addClickListener((event) {
    //   DriverBackgroundService.startAlert();
    // });

    OneSignal.Notifications.addForegroundWillDisplayListener((state) {
      state.notification.display();

      // 🔥 Start repeating alert service
      DriverBackgroundService.startAlert();
    });

    OneSignal.Notifications.addClickListener((event) {
      // 🔥 Also start if app was background
      DriverBackgroundService.startAlert();
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
      // 🌍 LANGUAGE CONFIG
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'en';
    setState(() {
      _locale = Locale(langCode);
    });
  }

  void changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    setState(() {
      _locale = locale;
    });
  }

  Future<void> _showLanguageDialogIfNeeded(BuildContext context,
      {bool force = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language_code');

    if (savedLang != null && !force) return;

    await Future.delayed(const Duration(milliseconds: 300));

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: ColorTheme().colorPrimarydark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const Text(
                  'Select Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  title: Text(
                    'English',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    MyApp.setLocale(
                      Navigator.of(context, rootNavigator: true).context,
                      const Locale('en'),
                    );
                    Navigator.pop(context);
                  },
                ),

                const Divider(),

                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  title: const Text('العربية',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    MyApp.setLocale(
                      Navigator.of(context, rootNavigator: true).context,
                      const Locale('ar'),
                    );
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

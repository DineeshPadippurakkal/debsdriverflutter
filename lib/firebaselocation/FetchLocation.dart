import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

const fetchLocationTask = "fetchLocationTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log("message");
    if (task == fetchLocationTask) {
      // Get location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Upload to Firebase
      DatabaseReference ref = FirebaseDatabase.instance.ref("locations/user1");
      await ref.set({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now().toIso8601String(),
      });
      log("✅ Location uploaded: ${position.latitude}, ${position.longitude}");
    }
    return Future.value(true);
  });
}


  
import 'package:flutter/material.dart';
import '../notification/driver_background_service.dart';

class DriverAlertScreen extends StatefulWidget {
  const DriverAlertScreen({super.key});

  @override
  State<DriverAlertScreen> createState() => _DriverAlertScreenState();
}

class _DriverAlertScreenState extends State<DriverAlertScreen> {

  @override
  void initState() {
    super.initState();
    DriverBackgroundService.startAlert();
  }

  @override
  void dispose() {
    DriverBackgroundService.stopAlert();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "NEW ORDER",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () {
                DriverBackgroundService.stopAlert();
                Navigator.pop(context);
              },
              child: const Text("ACCEPT"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () {
                DriverBackgroundService.stopAlert();
                Navigator.pop(context);
              },
              child: const Text("REJECT"),
            ),
          ],
        ),
      ),
    );
  }
}

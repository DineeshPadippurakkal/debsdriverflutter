import 'dart:io';

import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/issue/controller/ReportIssueController.dart';
import 'package:debs_driver_app/issue/model/ReportIssueTypeRespone.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  bool isloading = false;
    bool _loading = false;
  int? selectedIssueId;
  String? selectedIssue;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController noteController = TextEditingController();
  ReportIssueTypeRespone issueTypes = ReportIssueTypeRespone();

  // late List<String> issueTypes  ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchIssueTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Issue",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorTheme().colorPrimary,
      ),
      body: Stack(
        children: [
          isloading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Issue Type (Spinner)
                      DropdownButtonFormField<int>(
                        initialValue: selectedIssueId,
                        decoration: const InputDecoration(
                          labelText: 'Issue Type',
                          border: OutlineInputBorder(),
                        ),
                        items: issueTypes.data == null
                            ? []
                            : issueTypes.data!
                                .map<DropdownMenuItem<int>>(
                                  (e) => DropdownMenuItem<int>(
                                    value: e.id,
                                    child: Text(e.name ?? ""),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedIssueId = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Notes
                      TextField(
                        controller: noteController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Upload Image Box
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: openCamera,
                          child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: selectedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.camera_alt,
                                          size: 50, color: Colors.grey),
                                      SizedBox(height: 10),
                                      Text(
                                        'UPLOAD IMAGE',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedIssueId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please select an issue type")),
                              );
                              return;
                            }

                            getCurrentLocation();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorTheme().colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'SUBMIT ISSUE',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );

    /// 🔄 FULL SCREEN LOADER
  }

  Future<void> openCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (photo != null) {
      setState(() {
        selectedImage = File(photo.path);
      });
    }
  }

  Future<void> fetchIssueTypes() async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await Reportissuecontroller().fetchissueTypes();

      if (data != null) {
        setState(() {
          issueTypes = data;
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      rethrow;
    }
  }

  Future<void> callSubmittIssueApi(double latitude, double longitude) async {
    try {
      // setState(() {
      //   isloading = true;
      // });
      final data = await Reportissuecontroller().callReportIssue(
        noteController.text.trim(), // description
        selectedIssueId!, // issue_type
        latitude, // latitude
        longitude, // longitude
        selectedImage,
      );

      if (data != null) {
        setState(() {
          _loading = false;
        });
        // ✅ success
        clearAllFields();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Issue submitted successfully")),
        );
      } else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit issue")),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      rethrow;
    }
  }

  void clearAllFields() {
    noteController.clear();

    setState(() {
      selectedIssueId = null;
      selectedImage = null;
      // optional:
      // currentLatitude = null;
      // currentLongitude = null;
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      _loading = true;
    });
    // 🔍 Check service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    // 🔐 Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    // 📍 Get position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await callSubmittIssueApi(position.latitude, position.longitude);

    debugPrint("LAT: ${position.latitude}, LNG: ${position.longitude}");
  }
}

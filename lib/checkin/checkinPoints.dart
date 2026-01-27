import 'dart:async';
import 'dart:developer';

import 'package:debs_driver_app/checkin/controller/CheckinpointsController.dart';
import 'package:debs_driver_app/checkin/model/CheckinpointsResponse.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckinPointsBottomSheet extends StatefulWidget {
  const CheckinPointsBottomSheet({super.key});

  @override
  State<CheckinPointsBottomSheet> createState() =>
      _CheckinPointsBottomSheetState();
}

class _CheckinPointsBottomSheetState extends State<CheckinPointsBottomSheet> {
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  late BitmapDescriptor carIcon;
  bool _isMapLoaded = false;

  CheckinpointsResponse response = CheckinpointsResponse();
  Checkinpointscontroller checkinpointscontroller = Checkinpointscontroller();

  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(10.42796133580664, 10.885749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _setCustomMapPin();
    _getCurrentLocation();
    getCheckinPoints();
  }

  void _setCustomMapPin() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(20, 20)
        ,),
      'assets/images/allowcar.png',
    );
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final LatLng newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newPosition;

        _markers.removeWhere((m) => m.markerId.value == "current_location");
        _markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: newPosition,
            infoWindow: const InfoWindow(title: "You are here"),
            icon: carIcon,
          ),
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 16),
        ),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }
  }

  Future<void> getCheckinPoints() async {
    try {
      final data = await checkinpointscontroller.getCheckinPoints();
      if (data != null && data.data?.points != null) {
        setCheckinLocations(data.data!.points!);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void setCheckinLocations(List<Points> list) {
    debugPrint("Setting ${list.length} check-in points...");

    _markers.removeWhere((m) => m.markerId.value.startsWith("checkin_"));
    _circles.removeWhere((c) => c.circleId.value.startsWith("radius_circle_"));

    for (int i = 0; i < list.length; i++) {
      final point = list[i];
      if (point.lat != null && point.long != null) {
        final LatLng position = LatLng(point.lat!, point.long!);

        _markers.add(
          Marker(
            markerId: MarkerId("checkin_${i + 1}"),
            position: position,
            infoWindow: InfoWindow(
              snippet: "Lat: ${point.lat}, Lng: ${point.long}",
            ),
          ),
        );

        _circles.add(
          Circle(
            circleId: CircleId("radius_circle_${i + 1}"),
            center: position,
            radius: 500,
            fillColor: Colors.blueAccent.withOpacity(0.2),
            strokeColor: Colors.blueAccent,
            strokeWidth: 2,
          ),
        );
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: const Text(
              "Check-in Points",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              mapType: MapType.normal,
              myLocationEnabled: true,
              compassEnabled: true,
              markers: _markers,
              circles: _circles,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraIdle: () {
                if (!_isMapLoaded) {
                  setState(() => _isMapLoaded = true);
                }
              },
            ),
          ),
          // ⏳ Show loading overlay until map fully loaded
          if (!_isMapLoaded)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

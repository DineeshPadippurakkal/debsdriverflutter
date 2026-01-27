import 'dart:async';
import 'package:flutter/material.dart';

class DeliveryTimer extends StatefulWidget {
  final int expectedDeliveryTs; // milliseconds since epoch

  const DeliveryTimer({
    super.key,
    required this.expectedDeliveryTs,
  });

  @override
  State<DeliveryTimer> createState() => _DeliveryTimerState();
}

class _DeliveryTimerState extends State<DeliveryTimer> {
  Timer? _timer;
  Duration remaining = Duration.zero;
  Duration total = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initTimer();
    _startTimer();
  }

  void _initTimer() {
    final deliveryTime =
        DateTime.fromMillisecondsSinceEpoch(widget.expectedDeliveryTs);
    total = deliveryTime.difference(DateTime.now());
    remaining = total.isNegative ? Duration.zero : total;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remaining -= const Duration(seconds: 1);
        if (remaining.isNegative) {
          remaining = Duration.zero;
          timer.cancel();
        }
      });
    });
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = total.inSeconds == 0
        ? 0.0
        : remaining.inSeconds / total.inSeconds;

    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(
              remaining == Duration.zero ? Colors.red : Colors.green,
            ),
          ),
          Text(
            _format(remaining),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: remaining == Duration.zero ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

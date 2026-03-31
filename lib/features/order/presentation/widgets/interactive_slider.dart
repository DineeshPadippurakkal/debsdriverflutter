import 'package:flutter/material.dart';

class InteractiveSlider extends StatefulWidget {
  const InteractiveSlider({super.key, required this.onConfirmed});
  final VoidCallback onConfirmed;

  @override
  State<InteractiveSlider> createState() => _InteractiveSliderState();
}

class _InteractiveSliderState extends State<InteractiveSlider> {
  double _dragValue = 5;
  final double _maxWidth = 300; // This will adjust based on screen width
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _isFinished ? Colors.green : const Color(0xFF1A1C1E),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: (_isFinished ? Colors.green : Colors.black).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            double localMaxWidth = constraints.maxWidth - 70; // Subtract button width

            return Stack(
              children: [
                // Background Text
                Center(
                  child: Text(
                    _isFinished ? "REACHED" : "SLIDE TO CONFIRM",
                    style: TextStyle(
                      color: _isFinished ? Colors.white : Colors.white24,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // The Draggable Handle
                AnimatedPositioned(
                  duration: Duration(milliseconds: _dragValue == 5 ? 300 : 0),
                  left: _dragValue,
                  top: 5,
                  bottom: 5,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (_isFinished) return;
                      setState(() {
                        _dragValue += details.delta.dx;
                        // Prevent dragging out of bounds
                        if (_dragValue < 5) _dragValue = 5;
                        if (_dragValue > localMaxWidth) _dragValue = localMaxWidth;
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_isFinished) return;
                      setState(() {
                        // If dragged more than 80%, snap to end, otherwise snap back
                        if (_dragValue > localMaxWidth * 0.8) {
                          _dragValue = localMaxWidth;
                          // _isFinished = true;
                          widget.onConfirmed();
                        } else {
                          _dragValue = 5;
                        }
                      });
                    },
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: _isFinished ? Colors.white : Colors.blueAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Icon(
                        _isFinished ? Icons.check : Icons.arrow_forward,
                        color: _isFinished ? Colors.green : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

}
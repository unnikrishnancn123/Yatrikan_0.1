import 'package:flutter/material.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height); // Move to the bottom-left corner
    path.lineTo(0, size.height - 40); // Move up a bit from the bottom
    path.quadraticBezierTo(size.width / 4, size.height - 60, size.width / 2, size.height - 40); // Create a curve
    path.quadraticBezierTo(size.width * 3 / 4, size.height - 20, size.width, size.height - 40); // Create another curve
    path.lineTo(size.width, size.height); // Go to the bottom-right corner
    path.close(); // Close the path to complete the shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


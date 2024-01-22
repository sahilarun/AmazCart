import 'package:flutter/material.dart';

class SkewCutRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(20, 0.0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SkewCutRight oldClipper) => false;
}

class SkewCutLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);

    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SkewCutRight oldClipper) => false;
}

class SkewCutBottomLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height);
    path0.lineTo(size.width, size.height);
    path0.lineTo(size.width * 0.8333333, 0);
    path0.lineTo(0, 0);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(SkewCutBottomLeft oldClipper) => false;
}

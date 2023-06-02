//客製化的path
import 'package:flutter/material.dart';

class BubbleClipper3 extends CustomClipper<Path> {
  final bool left;
  final bool top;

  ///The radius, which creates the curved appearance of the chat widget,
  ///has a default value of 5.
  final double radius;

  /// The "nip" creates the curved shape of the chat widget
  /// and has a default nipSize of 7.
  final double nipSize;

  /// The "nip" creates the curved shape of the chat widget
  /// offset show distance from bottom and has default value 10.
  final double offset;

  BubbleClipper3(
      {required this.left,
      this.top = true,
      this.radius = 5,
      this.offset = 10,
      this.nipSize = 7});

  @override
  Path getClip(Size size) {
    var path = Path();

    path.addRRect(RRect.fromLTRBR(0, 0 + nipSize, size.width,
        size.height - nipSize, Radius.circular(radius)));

    var path2 = Path();
    path2.moveTo(nipSize, 0);
    path2.lineTo(2 * nipSize, nipSize);
    path2.lineTo(0, nipSize);
    var path3 = Path();
    path3.lineTo(2 * nipSize, 0);
    path3.lineTo(nipSize, nipSize);
    path3.lineTo(0, 0);
    if (left) {
      if (top) {
        path.addPath(path2, Offset(nipSize, 0));
      } else {
        path.addPath(path3, Offset(nipSize, size.height - nipSize));
      }
    } else {
      if (top) {
        path.addPath(path2, Offset(size.width - 3 * nipSize, 0));
      } else {
        path.addPath(
            path3, Offset(size.width - 3 * nipSize, size.height - nipSize));
      }
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

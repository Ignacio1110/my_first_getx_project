import 'package:extended_image/extended_image.dart';
import 'package:flutter/painting.dart';

class MyLayerPainter extends EditorCropLayerPainter {
  const MyLayerPainter();

  void paint(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    paintMask(canvas, size, painter);
    paintLines(canvas, size, painter);
    // paintCorners(canvas, size, painter);
  }

  /// draw crop layer corners
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect cropRect = painter.cropRect;
    final Size cornerSize = painter.cornerSize;
    final double cornerWidth = cornerSize.width;
    final double cornerHeight = cornerSize.height;
    final Paint paint = Paint()
      ..color = painter.cornerColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(
        Path()
          ..moveTo(cropRect.left, cropRect.top)
          ..lineTo(cropRect.left + cornerWidth, cropRect.top)
          ..lineTo(cropRect.left + cornerWidth, cropRect.top + cornerHeight)
          ..lineTo(cropRect.left + cornerHeight, cropRect.top + cornerHeight)
          ..lineTo(cropRect.left + cornerHeight, cropRect.top + cornerWidth)
          ..lineTo(cropRect.left, cropRect.top + cornerWidth),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(cropRect.left, cropRect.bottom)
          ..lineTo(cropRect.left + cornerWidth, cropRect.bottom)
          ..lineTo(cropRect.left + cornerWidth, cropRect.bottom - cornerHeight)
          ..lineTo(cropRect.left + cornerHeight, cropRect.bottom - cornerHeight)
          ..lineTo(cropRect.left + cornerHeight, cropRect.bottom - cornerWidth)
          ..lineTo(cropRect.left, cropRect.bottom - cornerWidth),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(cropRect.right, cropRect.top)
          ..lineTo(cropRect.right - cornerWidth, cropRect.top)
          ..lineTo(cropRect.right - cornerWidth, cropRect.top + cornerHeight)
          ..lineTo(cropRect.right - cornerHeight, cropRect.top + cornerHeight)
          ..lineTo(cropRect.right - cornerHeight, cropRect.top + cornerWidth)
          ..lineTo(cropRect.right, cropRect.top + cornerWidth),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(cropRect.right, cropRect.bottom)
          ..lineTo(cropRect.right - cornerWidth, cropRect.bottom)
          ..lineTo(cropRect.right - cornerWidth, cropRect.bottom - cornerHeight)
          ..lineTo(
              cropRect.right - cornerHeight, cropRect.bottom - cornerHeight)
          ..lineTo(cropRect.right - cornerHeight, cropRect.bottom - cornerWidth)
          ..lineTo(cropRect.right, cropRect.bottom - cornerWidth),
        paint);
  }

  /// draw crop layer lines
  void paintMask(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect rect = Offset.zero & size;
    final Rect cropRect = painter.cropRect;
    final Color maskColor = painter.maskColor;
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = maskColor);
    canvas.drawCircle(cropRect.center, cropRect.width / 2,
        Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  /// draw crop layer lines
  void paintLines(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Color lineColor = painter.lineColor;
    final double lineHeight = painter.lineHeight;
    final Rect cropRect = painter.cropRect;
    final bool pointerDown = painter.pointerDown;
    final Paint linePainter = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight
      ..style = PaintingStyle.stroke;
    canvas.drawRect(cropRect, linePainter);

    if (pointerDown) {
      canvas.drawLine(
          Offset((cropRect.right - cropRect.left) / 3.0 + cropRect.left,
              cropRect.top),
          Offset((cropRect.right - cropRect.left) / 3.0 + cropRect.left,
              cropRect.bottom),
          linePainter);

      canvas.drawLine(
          Offset((cropRect.right - cropRect.left) / 3.0 * 2.0 + cropRect.left,
              cropRect.top),
          Offset((cropRect.right - cropRect.left) / 3.0 * 2.0 + cropRect.left,
              cropRect.bottom),
          linePainter);

      canvas.drawLine(
          Offset(
            cropRect.left,
            (cropRect.bottom - cropRect.top) / 3.0 + cropRect.top,
          ),
          Offset(
            cropRect.right,
            (cropRect.bottom - cropRect.top) / 3.0 + cropRect.top,
          ),
          linePainter);

      canvas.drawLine(
          Offset(cropRect.left,
              (cropRect.bottom - cropRect.top) / 3.0 * 2.0 + cropRect.top),
          Offset(
            cropRect.right,
            (cropRect.bottom - cropRect.top) / 3.0 * 2.0 + cropRect.top,
          ),
          linePainter);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:my_painter/model/paint_data.dart';

class PaintHistory {
  final List<PaintData> _paintDataList = [];
  final List<PaintData> _undoList = [];

  final _backgroundPaint = Paint();

  bool _inDrag = false;

  final Paint currentPaint;

  PaintHistory(this.currentPaint);

  bool get canUndo => _paintDataList.isNotEmpty;
  bool get canRedo => _undoList.isNotEmpty;

  set backgroundColor(Color color) => _backgroundPaint.color = color;

  void undo() {
    if (canUndo) {
      _undoList.add(_paintDataList.removeLast());
    }
  }

  void redo() {
    if (canRedo) {
      _paintDataList.add(_undoList.removeLast());
    }
  }

  void clear() {
    _paintDataList.clear();
  }

  void addPaint(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;

      final path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);

      final data = PaintData(path: path, paint: currentPaint);
      _paintDataList.add(data);
    }
  }

  void updatePaint(Offset nextPoint) {
    if (_inDrag) {
      final lastPath = _paintDataList.last.path;
      lastPath.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endPaint() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _backgroundPaint,
    );

    for (final data in _paintDataList) {
      canvas.drawPath(data.path, data.paint);
    }
  }
}


class PaintHistory2 {
  final List<PaintData> _paintDataList = [];

  final _backgroundPaint = Paint();

  bool _inDrag = false;

  final Paint currentPaint;

  PaintHistory2(this.currentPaint);

  bool get canUndo => _paintDataList.isNotEmpty;

  set backgroundColor(Color color) => _backgroundPaint.color = color;

  void addPaint(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;

      final path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);

      final data = PaintData(path: path, paint: currentPaint);
      _paintDataList.add(data);
    }
  }

  void updatePaint(Offset nextPoint) {
    if (_inDrag) {
      final lastPath = _paintDataList.last.path;
      lastPath.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endPaint() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _backgroundPaint,
    );

    for (final data in _paintDataList) {
      canvas.drawPath(data.path, data.paint);
    }
  }
}

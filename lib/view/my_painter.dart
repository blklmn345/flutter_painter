import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_painter/model/paint_history.dart';

final _paintConfigProvider = StateProvider((ref) {
  final paint = Paint();
  paint.color = Colors.black;
  paint.style = PaintingStyle.stroke;
  paint.strokeWidth = 5;

  return paint;
});

final _paintHistoryProvider =
    ChangeNotifierProvider<PaintHistoryNotifier>((ref) {
  return PaintHistoryNotifier(ref.watch(_paintConfigProvider));
});

class PaintHistoryNotifier extends ChangeNotifier {
  final Paint currentPaint;

  late final PaintHistory paintHistory;

  PaintHistoryNotifier(this.currentPaint) {
    paintHistory = PaintHistory(currentPaint);
    paintHistory.backgroundColor = Colors.white;
  }

  void addPaint(Offset startPoint) {
    paintHistory.addPaint(startPoint);
    notifyListeners();
  }

  void updatePaint(Offset nextPoint) {
    paintHistory.updatePaint(nextPoint);
    notifyListeners();
  }

  void endPaint() {
    paintHistory.endPaint();
    notifyListeners();
  }

  void undo() {
    paintHistory.undo();
    notifyListeners();
  }

  void redo() {
    paintHistory.redo();
    notifyListeners();
  }

  void clear() {
    paintHistory.clear();
  }
}

class MyPainter extends ConsumerStatefulWidget {
  const MyPainter({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPainter> createState() => _MyPainterState();
}

class _MyPainterState extends ConsumerState<MyPainter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painter'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: GestureDetector(
            onPanStart: _onPaintStart,
            onPanUpdate: _onPaintUpdate,
            onPanEnd: _onPaintEnd,
            child: CustomPaint(
              painter: _CustomPainter(
                paintHistory: ref.watch(_paintHistoryProvider).paintHistory,
                repaint: ref.watch(_paintHistoryProvider),
              ),
              willChange: true,
              child: const SizedBox.expand(),
            ),
          ),
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              ref.read(_paintHistoryProvider).redo();
            },
            child: const Icon(Icons.redo),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              ref.read(_paintHistoryProvider).undo();
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              ref.read(_paintHistoryProvider).clear();
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  void _onPaintStart(DragStartDetails start) {
    ref.read(_paintHistoryProvider).addPaint(start.localPosition);
  }

  void _onPaintUpdate(DragUpdateDetails update) {
    ref.read(_paintHistoryProvider).updatePaint(update.localPosition);
  }

  void _onPaintEnd(DragEndDetails end) {
    ref.read(_paintHistoryProvider).endPaint();
  }
}

class _CustomPainter extends CustomPainter {
  final PaintHistory paintHistory;

  _CustomPainter({
    required this.paintHistory,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    paintHistory.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

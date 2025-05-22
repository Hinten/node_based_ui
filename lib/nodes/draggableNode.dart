import 'package:flutter/material.dart';
import 'package:graph_project/nodes/node.dart';
import 'package:graph_project/nodes/nodeProvider.dart';
import 'package:provider/provider.dart';

class DraggableNode extends StatefulWidget {
  final int index;
  const DraggableNode({
    super.key,
    required this.index,
  });

  @override
  State<DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<DraggableNode> {

  Offset dragStart = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: context.watch<NodesProvider>().getNode(widget.index).position.dx,
      top: context.watch<NodesProvider>().getNode(widget.index).position.dy,
      child: GestureDetector(
        onPanStart: (details) {
          dragStart = details.globalPosition;
        },
        onPanUpdate: (details) {
          final delta = details.globalPosition - dragStart;
          dragStart = details.globalPosition;

          // Atualiza a posição do nó
          final newPosition = context.read<NodesProvider>().getNode(widget.index).position + delta;
          context.read<NodesProvider>().updateNode(widget.index, newPosition);

        },


        child: Container(
          width: context.watch<NodesProvider>().getNode(widget.index).width,
          height: context.watch<NodesProvider>().getNode(widget.index).height,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          alignment: Alignment.center,
          child: Text(context.watch<NodesProvider>().getNode(widget.index).label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class DrawLine extends StatefulWidget {
  final Node start;
  final Node end;
  const DrawLine({
    super.key,
    required this.start,
    required this.end,
  });

  @override
  State<DrawLine> createState() => _DrawLineState();
}

class _DrawLineState extends State<DrawLine> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: ConnectionPainter(
        start: widget.start.position + Offset(widget.start.width, widget.start.height / 2),
        end: widget.end.position + Offset(0, widget.end.height / 2),
      ),
    );
  }
}



class ConnectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  ConnectionPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    // Cria curva de Bezier
    final controlPoint1 = Offset(start.dx + 100, start.dy);
    final controlPoint2 = Offset(end.dx - 100, end.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graph_project/nodes/node.dart';


class NodesProvider with ChangeNotifier{

  List<Node> nodes = [
    Node.placeholder(label: "Nó 1", x: 100, y: 100),
    Node.placeholder(label: "Nó 2", x: 200, y: 200),
  ];

  void updateNode(int index, Offset newPosition) {
    if (index < 0 || index >= nodes.length) {
      throw Exception("Index out of range");
    }
    nodes[index] = nodes[index].copyWith(x: newPosition.dx, y: newPosition.dy);
    notifyListeners();
  }

  Node getNode(int index) {
    if (index < 0 || index >= nodes.length) {
      throw Exception("Index out of range");
    }
    return nodes[index];
  }


}
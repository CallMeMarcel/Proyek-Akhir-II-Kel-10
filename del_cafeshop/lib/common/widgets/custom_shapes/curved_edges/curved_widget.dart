import 'package:del_cafeshop/common/widgets/custom_shapes/curved_edges/curved.dart';
import 'package:flutter/material.dart';

class CurvedEdgeWidget extends StatelessWidget {
  const CurvedEdgeWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapesEdges() ,
      child: child,
    );
  }
}
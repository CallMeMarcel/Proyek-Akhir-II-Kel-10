import 'package:del_cafeshop/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/curved_edges/curved_widget.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class PrimaryHeaderController extends StatelessWidget {
  const PrimaryHeaderController({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgeWidget(
        child: Container(
          color: TColors.primary,
          child: Stack(
            children: [
              /// Background Custom Shapes
              Positioned(
                top: -150 ,right: -250 ,child: CircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
              Positioned(
                top: 100 ,right: -300 ,child:CircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
                child,
            ],
          ),
        ),
    );
  }
}


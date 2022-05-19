import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/xcontext.dart' show Context;

class BuildPostDetailsShimmer extends StatelessWidget {
  const BuildPostDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Shimmer.fromColors(
        child: Column(children: [
          Container(
            height: 80,
            width: context.deviceHeight,
            decoration: const BoxDecoration(color: Colors.green),
          )
        ]),
        baseColor: Colors.grey.withOpacity(0.7),
        highlightColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}

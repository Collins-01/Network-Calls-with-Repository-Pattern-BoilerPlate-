import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderPage extends StatelessWidget {
  final Widget child;
  final bool isBusy;

  const LoaderPage({Key? key, required this.child, this.isBusy = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          if (isBusy)
            Container(
              color: Colors.black.withOpacity(.5),
            ),
          if (isBusy)
            const Center(
              child: SpinKitChasingDots(
                color: Colors.white,
                duration: Duration(milliseconds: 900),
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}

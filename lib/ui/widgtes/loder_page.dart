import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderPage extends StatelessWidget {
  final Widget child;
  final bool isBusy;
  final VoidCallback? onCancel;

  const LoaderPage(
      {Key? key, required this.child, this.isBusy = false, this.onCancel})
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
            Center(
                child: Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SpinKitChasingDots(
                              color: Colors.blue,
                              duration: Duration(milliseconds: 900),
                              size: 45,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Loading 90%",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.clear_circled,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ))),
        ],
      ),
    );
  }
}

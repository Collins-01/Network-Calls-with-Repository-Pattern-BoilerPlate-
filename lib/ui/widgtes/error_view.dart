import 'package:flutter/material.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';

class ErrorView extends StatelessWidget {
  final Failure? failure;
  final VoidCallback? retry;
  const ErrorView({Key? key, required this.retry, required this.failure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(failure!.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(
              failure!.message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        InkWell(
          onTap: retry,
          child: Container(
            height: 42,
            width: MediaQuery.of(context).size.width * 0.89,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Retry",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

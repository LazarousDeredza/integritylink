import 'package:flutter/material.dart';

class ButtonLoadingWidget extends StatelessWidget {
  const ButtonLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Loading...",
        ),
      ],
    );
  }
}
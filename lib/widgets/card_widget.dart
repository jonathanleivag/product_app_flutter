import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget child;

  const CardWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
            blurRadius: 50,
            blurStyle: BlurStyle.normal,
          )
        ]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: boxDecoration,
        child: child,
      ),
    );
  }
}

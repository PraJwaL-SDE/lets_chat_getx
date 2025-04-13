import 'package:flutter/cupertino.dart';

import '../../../utils/constants/constant_colors.dart';

class CustomAppBar extends StatelessWidget {
  final Widget child;
  const CustomAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 70,
      duration: Duration(seconds: 300),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(height: 40,child: child),
        ),
      ),
      color: ConstantColors.appbar,
    );
  }
}

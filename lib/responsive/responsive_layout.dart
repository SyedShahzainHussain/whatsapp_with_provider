import 'package:flutter/material.dart';

class ResponsiveLauyout extends StatelessWidget {
  final Widget mobileScreenWidget;
  final Widget webScreenWidget;
  const ResponsiveLauyout(
      {super.key,
      required this.mobileScreenWidget,
      required this.webScreenWidget});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 960) {
          return webScreenWidget;
        }
        return mobileScreenWidget;
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../utils/asset_images.dart';

class AppBackgroundWidget extends StatelessWidget {
  final Widget child;
  const AppBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.contain,
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}

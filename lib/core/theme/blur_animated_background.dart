import 'dart:ui';

import 'package:articles_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlurAnimationBG extends StatefulWidget {
  const BlurAnimationBG({super.key});

  @override
  State<BlurAnimationBG> createState() => _BlurAnimationBGState();
}

class _BlurAnimationBGState extends State<BlurAnimationBG> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          alignment: Alignment.topRight,
          child: colorBox(Colors.transparent, AppPallete.gradient2)),
      Align(
          alignment: Alignment.center,
          child: colorBox(AppPallete.gradient2, AppPallete.gradient3)),
      Align(
          alignment: Alignment.bottomCenter,
          child: colorBox(AppPallete.gradient3, Colors.transparent)),
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(color: Colors.transparent)),
    ]);
  }
}

Widget colorBox(Color color1, Color color2) {
  return TweenAnimationBuilder(
    tween: ColorTween(
      begin: color1,
      end: color2,
    ),
    duration: const Duration(seconds: 3),
    builder: (context, color, child) {
      return Stack(children: [
        Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ]);
    },
  );
}

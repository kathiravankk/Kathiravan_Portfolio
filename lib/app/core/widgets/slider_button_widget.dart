import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class SliderButtonWidget extends StatefulWidget {
  final VoidCallback onCompleted;

  const SliderButtonWidget({super.key, required this.onCompleted});

  @override
  State<SliderButtonWidget> createState() => _SliderButtonWidgetState();
}

class _SliderButtonWidgetState extends State<SliderButtonWidget> {
  double dragX = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        const knobSize = 52.0;
        final maxDrag = trackWidth - knobSize - 8;

        return Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Color(0xFF8FFFFD),
                Color(0xFF3FE6E1),],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF69FFF8).withValues(alpha: 0.6),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  "Get Started",
                  style: AppStyles.customTextStyle(
                    size: 26,
                    weight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ),

              Positioned(
                left: dragX + 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      dragX += details.delta.dx;
                      dragX = dragX.clamp(0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (dragX >= maxDrag * 0.85) {
                      setState(() {
                        dragX = maxDrag;
                      });

                      widget.onCompleted();
                    } else {
                      setState(() {
                        dragX = 0;
                      });
                    }
                  },
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: const BoxDecoration(
                      color: Color(0xFF102D34),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

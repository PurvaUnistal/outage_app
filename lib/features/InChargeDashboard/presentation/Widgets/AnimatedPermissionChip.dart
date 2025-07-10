import 'package:flutter/material.dart';

class AnimatedPermissionChip extends StatelessWidget {
  final String label;
  final bool granted;

  const AnimatedPermissionChip(
      {super.key, required this.label, required this.granted});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Chip(
            label: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
            backgroundColor: granted ? Colors.green : Colors.red,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }
}

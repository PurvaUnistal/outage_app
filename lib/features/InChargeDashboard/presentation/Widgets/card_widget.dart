import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final String path;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  const CardWidget({
    Key? key,
    required this.text,
    required this.path,
    this.onTap,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      path,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  text,
                  style: textStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

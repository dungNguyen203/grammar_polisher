import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final bool isDisabled;
  final double borderRadius;
  final EdgeInsets? padding;
  final BorderSide? borderSide;
  final bool expand;
  final Color? overlayColor;

  const RoundedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.isDisabled = false,
    this.borderRadius = 100,
    this.padding,
    this.borderSide,
    this.expand = true,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide ?? BorderSide.none,
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        backgroundColor: backgroundColor,
        overlayColor: overlayColor,
      ),
      onPressed: isDisabled ? null : onPressed,
      child: expand
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [child],
            )
          : child,
    );
  }
}

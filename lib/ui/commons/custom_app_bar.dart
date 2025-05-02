import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'cupertino_back_button.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final List<Widget> actions;

  const CustomAppBar({super.key, this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canPop = context.canPop();
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                canPop
                  ? ShadowButton(
                    onPress: () {
                      context.pop();
                    },
                    child: const Icon(Icons.arrow_back_ios_new),
                  )
                  : const SizedBox.shrink(),
              ],
            ),
          ),
          Center(
            child:
                title != null
                    ? Center(
                      child: Text(
                        title!,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}

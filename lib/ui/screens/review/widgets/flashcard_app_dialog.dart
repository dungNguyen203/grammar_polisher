import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/assets.dart';
import '../../../commons/rounded_button.dart';

class FlashcardAppDialog extends StatelessWidget {
  const FlashcardAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(
        'Do you like our flashcards?',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                Assets.pngXlsxDemo,
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'Our ',
                ),
                WidgetSpan(
                  child: Image.asset(
                    Assets.pngImg1,
                    height: 18,
                  ),
                ),
                TextSpan(
                  text: ' Flashcard Collections App',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: ' helps you create your own flashcards.',
                ),
                TextSpan(
                  text: ' Especially useful with ',
                ),
                TextSpan(
                  text: 'XLSX import',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: ' feature.\nHope you enjoy it!',
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        RoundedButton(
          onPressed: () => _onGotIt(context),
          child: Text("Got it!"),
        ),
        const SizedBox(height: 8),
        RoundedButton(
          backgroundColor: colorScheme.secondaryContainer,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Don't show again",
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  _onGotIt(BuildContext context) {
    final url = Platform.isIOS
        ? const String.fromEnvironment('IOS_FLASHCARD_APP_URL')
        : const String.fromEnvironment('ANDROID_FLASHCARD_APP_URL');
    launchUrl(Uri.parse(url));
    Navigator.of(context).pop();
  }
}

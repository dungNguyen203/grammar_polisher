import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../generated/assets.dart';
import '../blocs/iap/iap_bloc.dart';
import 'paywall_page.dart';
import 'rounded_button.dart';

class PurchaseSuccessDialog extends StatelessWidget {
  const PurchaseSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final spacing = 8.0;
    return BlocBuilder<IapBloc, IapState>(
      builder: (context, state) {
        return Stack(
          children: [
            Dialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(color: colorScheme.primary, width: 0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          Assets.pngLauncher,
                          height: size.height * 0.1,
                        ),
                      ),
                      SizedBox(height: 2 * spacing),
                      Text(
                        "Welcome to Premium",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      PaywallPage(),
                      SizedBox(height: spacing),
                      RoundedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Getting Started",
                          style: textTheme.titleSmall?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IgnorePointer(child: Center(child: Lottie.asset(addRepaintBoundary: false, Assets.lottieConfetti, repeat: false))),
          ],
        );
      },
    );
  }
}

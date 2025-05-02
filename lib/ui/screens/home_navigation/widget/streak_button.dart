import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../generated/assets.dart';
import '../../streak/bloc/streak_bloc.dart';

class StreakButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StreakButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        final percent = state.spentTimeToday / StreakBloc.timePerDayNeeded;
        return Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(1000),
          child: InkWell(
            borderRadius: BorderRadius.circular(1000),
            onTap: onPressed,
            child: CircularPercentIndicator(
              radius: 24.0,
              lineWidth: 4.0,
              circularStrokeCap: CircularStrokeCap.round,
              percent: percent > 1 ? 1 : percent,
              center: Image.asset(state.streak != 0 ? Assets.pngFlame : Assets.pngFlameInactive, height: 20),
              progressColor: Color(0xFFf5a623),
            ),
          ),
        );
      },
    );
  }
}

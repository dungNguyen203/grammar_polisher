import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/assets.dart';
import '../blocs/iap/iap_bloc.dart';
import 'dialogs/paywall_dialog.dart';
import 'svg_button.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const AppHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final iapState = context.watch<IapBloc>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          Row(
            children: [
              if (Navigator.of(context).canPop())
                SvgButton(
                  svg: Assets.svgArrowBackIos,
                  color: colorScheme.primary,
                  onPressed: () => _onClose(context),
                )
              else
                _getPremiumButton(context, iapState.boughtNoAdsTime),
              const Spacer(),
              ...actions,
            ],
          ),
        ],
      ),
    );
  }

  _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onRemoveAds(BuildContext context) {
    showDialog(context: context, builder: (_) => PaywallDialog());
  }

  Widget _getPremiumButton(BuildContext context, int? time) {
    if (time == null) {
      return TextButton(
        onPressed: () {
          _onRemoveAds(context);
        },
        child: Row(children: [const Icon(Icons.star), const SizedBox(width: 8), Text('Remove Ads')]),
      );
    }
    if (time == -1) {
      return TextButton(
        onPressed: () {},
        child: Row(children: [const Icon(Icons.star), const SizedBox(width: 8), Text('Premium')]),
      );
    }
    final day = DateTime.fromMillisecondsSinceEpoch(time).difference(DateTime.now()).inDays + 1;
    return TextButton(
      onPressed: () {
        _onRemoveAds(context);
      },
      child: Row(
        children: [
          const Icon(Icons.check),
          const SizedBox(width: 8),
          Text(day == 0 ? "No Ads Today" : '$day Day${day > 1 ? 's' : ''} No Ads'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class BrandAppBarTitle extends StatelessWidget {
  const BrandAppBarTitle({super.key, required this.sectionTitle});

  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            size: 16,
            color: colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.appName,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            Text(
              sectionTitle,
              style: textTheme.labelSmall?.copyWith(color: subtitleColor),
            ),
          ],
        ),
      ],
    );
  }
}

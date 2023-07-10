import 'package:flutter/material.dart';

import 'elements.dart';

PreferredSize customAppBar(BuildContext context, String text1, String text2) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80.0),
    child: AppBar(
      leading: null,
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      foregroundColor: Colors.black,
      title: Center(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              textWidget(text1, 20.0, Theme.of(context).colorScheme.tertiary),
              textWidget(text2, 30.0, Theme.of(context).colorScheme.tertiary)
            ]),
          ])),
    ),
  );
}
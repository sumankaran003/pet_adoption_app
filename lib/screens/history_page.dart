import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../WidgetLibrary/custome_app_bar.dart';
import '../WidgetLibrary/elements.dart';
import '../provider/fetch_history_provider.dart';

class HistoryPage extends HookWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<AdoptionHistoryProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      petProvider.fetchAdoptedPets();
    });

    return Scaffold(
      appBar: customAppBar(context, "Adoption ","History"),
      body: Center(
        child: Consumer<AdoptionHistoryProvider>(
          builder: (context, provider, _) {
            if (provider.adoptedPets.isEmpty) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 210,
                        child:
                        Lottie.asset('assets/lottie/not_found.json')),
                    textWidget("No adoption history found", 24.0, Theme.of(context).colorScheme.tertiary),
                  ]);
            } else {
              return Container(
                color: Theme.of(context).colorScheme.background,
                child: ListView.builder(
                  itemCount: provider.adoptedPets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final pet = provider.adoptedPets[index];
                    return historyListElement(pet, context);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

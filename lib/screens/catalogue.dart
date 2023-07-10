import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../WidgetLibrary/custome_app_bar.dart';
import '../WidgetLibrary/elements.dart';
import 'details_page.dart';
import '../provider/fetch_all_pets_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({super.key});

  @override
  State<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      petProvider.fetchInitialPets();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      //PAGINATION (When scroll reaches the end point, it will load the next batch)
      Provider.of<PetProvider>(context, listen: false).fetchNextPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Adopt your ", "Soulmate"),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(children: [
          SearchBar(),
          Expanded(
            child: Consumer<PetProvider>(
              builder: (context, provider, _) {
                if (provider.pets.isEmpty) {
                  return Center(
                    child: SizedBox(
                        width: 310,
                        child: Lottie.asset('assets/lottie/dog_running.json')),
                  );
                } else {
                  return GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: provider.pets.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == provider.pets.length) {
                        if (provider.hasMorePets) {
                          return Center(
                            child: Center(
                              child: SizedBox(
                                  width: 310,
                                  child: Lottie.asset(
                                      'assets/lottie/dog_running.json')),
                            ),
                          );
                        } else {
                          return Container(); // No more pets to load
                        }
                      }
                      final pet = provider.pets[index];
                      return GestureDetector(
                        onTap: () {

                          // Get.to(() =>  DetailsPage(
                          //   petModel: provider.pets[index],
                          //   index: index,
                          // ),
                          //     transition: Transition.fade,
                          //     duration: Duration(seconds: 1));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                      petModel: provider.pets[index],
                                      index: index,
                                    )),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Stack(children: [
                                    Hero(
                                      tag: pet.imageLink,
                                      child: cardImage(pet.imageLink),
                                    ),
                                    shadow(),
                                  ]),
                                  Positioned(
                                    left: 10.0,
                                    bottom: 10.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        textWidget(
                                            capitalizeFirstLetters(pet.breed),
                                            18.0,
                                            Colors.white),
                                        textWidget(
                                          provider.pets[index].isSold
                                              ? "Already Adopted"
                                              : "Available",
                                          13.0,
                                          provider.pets[index].isSold
                                              ? Colors.redAccent
                                                  .withOpacity(0.7)
                                              : Colors.greenAccent
                                                  .withOpacity(0.8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}

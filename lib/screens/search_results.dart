import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../WidgetLibrary/custome_app_bar.dart';
import '../WidgetLibrary/elements.dart';
import '../provider/search_provider.dart';
import 'details_page_2.dart';

class SearchResult extends StatefulWidget {
  final String searchedTerm;

  const SearchResult({Key? key, required this.searchedTerm}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petProvider = Provider.of<SearchProvider>(context, listen: false);
      petProvider.fetchSearchedPets(widget.searchedTerm);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Find your ", "Soulmate"),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    controller: _searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary)),
                      filled: true,
                      hintText: 'Search by Breed...',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        // Set the border color to white
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Handle search button press
                    String searchQuery = _searchController.text;
                    final petProvider =
                        Provider.of<SearchProvider>(context, listen: false);
                    petProvider.fetchSearchedPets(searchQuery.toLowerCase());
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                if (provider.searchedPets.isEmpty) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 210,
                            child:
                                Lottie.asset('assets/lottie/not_found.json')),
                        textWidget("No result found", 24.0, Colors.black54),
                      ]);
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: provider.searchedPets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final pet = provider.searchedPets[index];
                      return GestureDetector(
                        onTap: () {
                          // Get.to(
                          //     () => DetailsPage2(
                          //           petModel: provider.searchedPets[index],
                          //           index: index,
                          //         ),
                          //     transition: Transition.fade,
                          //     duration: Duration(seconds: 1));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage2(
                                      petModel: provider.searchedPets[index],
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
                                          provider.searchedPets[index].isSold
                                              ? "Already Adopted"
                                              : "Available",
                                          13.0,
                                          provider.searchedPets[index].isSold
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

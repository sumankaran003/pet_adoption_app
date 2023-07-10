import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:Soulmate/models/pet_model.dart';

import '../screens/search_results.dart';

Color shadowColor = const Color(0xff040C14);
Container cardImage(String img) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
    ),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          img,
          fit: BoxFit.cover,
          height: 200,
          width: 180,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        )),
  );
}

Positioned shadow() {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [shadowColor.withOpacity(0.7), Colors.transparent]),
      ),
    ),
  );
}

Text textWidget(String text, double size, Color color) {
  return Text(
    text,
    style: GoogleFonts.roboto(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget historyListElement(PetModel petModel, BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        margin: const EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
        height: 130.0,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
          color: Theme.of(context).colorScheme.onTertiary,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 120.0,
                    child: Text(
                      "Name: ${petModel.name}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              textWidget("Breed: ${capitalizeFirstLetters(petModel.breed)}", 16.0,
                  Theme.of(context).colorScheme.tertiary),
              const SizedBox(
                height: 5,
              ),
              textWidget("Time of Adoption: ${petModel.timestampOfAdoption}",
                  14.0, Theme.of(context).colorScheme.tertiary)
            ],
          ),
        ),
      ),
      Positioned(
        left: 20.0,
        top: 15.0,
        bottom: 15.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.network(
            petModel.imageLink,
            fit: BoxFit.cover,
            width: 110.0,
            height: 110.0,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                  width: 110,
                  child: Lottie.asset('assets/lottie/image_not_found.json'));
            },
          ),
        ),
      ),
    ],
  );
}

Widget petDetails(
    String name, String breed, int age, double price, BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 0.1,
            blurRadius: 0.1,
            offset: const Offset(0, 0.5),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onTertiary),
    padding: const EdgeInsets.only(left: 20.0),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          textWidget("Name: $name", 24, Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 8),
          textWidget(
              "Breed: ${capitalizeFirstLetters(breed)}", 16, Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 8),
          textWidget("Age: $age", 16, Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 8),
          textWidget("Price", 16, Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 2),
          textWidget("\$$price", 24, Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 20),
        ]),
  );
}

class SearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResult(
                          searchedTerm: searchQuery.toLowerCase(),
                        )),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget detailsPageImage(String imageLink) {
  return Hero(
    tag: imageLink,
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 0.5,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        child: Image.network(
          imageLink,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

String capitalizeFirstLetters(String input) {
  List<String> words = input.split(' ');

  for (int i = 0; i < words.length; i++) {
    String word = words[i];

    if (word.isNotEmpty) {
      String capitalizedWord =
          word[0].toUpperCase() + word.substring(1).toLowerCase();
      words[i] = capitalizedWord;
    }
  }

  return words.join(' ');
}

import 'package:flutter/material.dart';
import 'package:Soulmate/models/pet_model.dart';
import 'package:Soulmate/screens/full_screen_photo.dart';
import 'package:provider/provider.dart';

import 'package:Soulmate/WidgetLibrary/elements.dart';
import '../provider/search_provider.dart';
import 'confetti.dart';

class DetailsPage2 extends StatefulWidget {
  final int index;
  final PetModel petModel;

  const DetailsPage2({super.key, required this.petModel, required this.index});

  @override
  State<DetailsPage2> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage2> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Stack(children: [
          SizedBox(
            height: screenHeight * 0.60,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullScreenPhoto(
                          imageLink: widget.petModel.imageLink)),
                );
              },
              child: detailsPageImage(widget.petModel.imageLink),
            ),
          ),
        ]),
        petDetails(widget.petModel.name, widget.petModel.breed,
            widget.petModel.age, widget.petModel.price, context),
        Align(
          alignment: Alignment.center,
          child: Consumer<SearchProvider>(builder: (context, provider, _) {
            return ElevatedButton(
              onPressed: () {
                if (!provider.searchedPets[widget.index].isSold) {
                  provider.updateIsSold(widget.petModel.id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfettiPage(
                              name: widget.petModel.name,
                            )),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.searchedPets[widget.index].isSold
                    ? Colors.grey
                    : Colors.greenAccent, // Set the button's background color
                foregroundColor: Colors.white, // Set the text color
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 100), // Set padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Set border radius
                ),
                textStyle: const TextStyle(
                  fontSize: 16, // Set text size
                  fontWeight: FontWeight.bold, // Set text weight
                ),
                elevation: 4, // Set button elevation
              ),
              child: provider.searchedPets[widget.index].isSold
                  ? const Text('Already Adopted')
                  : const Text('Adopt Me'), // Set button text
            );
          }),
        )
      ]),
    ));
  }
}

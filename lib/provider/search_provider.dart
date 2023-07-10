import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/pet_model.dart';

class SearchProvider extends ChangeNotifier {
  List<PetModel> _searchedPets = [];

  List<PetModel> get searchedPets => _searchedPets;

  Future<void> fetchSearchedPets(String searchTerm) async {
    try {
      final query = FirebaseFirestore.instance
          .collection('pets')
          .where('breed', isGreaterThanOrEqualTo: searchTerm)
          .where('breed', isLessThan: '${searchTerm}z');

      query.snapshots().listen((snapshot) {
        final petsData = snapshot.docs.map((doc) {
          final data = doc.data();
          final id = doc.id;
          return PetModel(
            id: id,
            age: data['age'],
            name: data['name'],
            breed: data['breed'],
            price: data['price'],
            isSold: data['isSold'],
            imageLink: data['imageLink'],
            timestampOfAdoption: data['timestampOfAdoption']??="",
          );
        }).toList();

        _searchedPets = petsData;

        notifyListeners();
      });
    } catch (error) {
      // Handle the error gracefully
    }
  }

  Future<void> updateIsSold(String petId) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    try {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(petId)
          .update({'isSold': true,'timestampOfAdoption':formattedDate});

      // Fetch the updated pet data
      final snapshot =
      await FirebaseFirestore.instance.collection('pets').doc(petId).get();

      final petData = snapshot.data();
      PetModel? updatedPet;





      if (petData != null) {
        updatedPet = PetModel(
          id: petId,
          age: petData['age'],
          name: petData['name'],
          breed: petData['breed'],
          price: petData['price'],
          isSold: petData['isSold'],
          imageLink: petData['imageLink'],
          timestampOfAdoption: formattedDate,
        );
      }

      final petIndex = _searchedPets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        _searchedPets[petIndex] = updatedPet!;
      }

      notifyListeners();

      // Perform any additional operations or state updates if needed
    } catch (error) {
      // Handle the error gracefully
    }
  }
}

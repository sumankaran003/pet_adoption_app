import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class AdoptionHistoryProvider extends ChangeNotifier {
  List<PetModel> _adoptedPets = [];

  List<PetModel> get adoptedPets => _adoptedPets;

  Future<void> fetchAdoptedPets() async {
    try {
      final query = FirebaseFirestore.instance
          .collection('pets')
          .where('isSold', isEqualTo: true)
          .orderBy('timestampOfAdoption', descending: true);

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
            timestampOfAdoption: data['timestampOfAdoption'],
          );
        }).toList();

        _adoptedPets = petsData;
        notifyListeners();
      });
    } catch (error) {
      _adoptedPets=[];
    }
  }
}

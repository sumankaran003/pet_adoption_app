import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';
import 'package:intl/intl.dart';
class PetProvider extends ChangeNotifier {
  List<PetModel> _pets = [];
  List<PetModel> _adoptedPets = [];
  final int _batchSize = 10;
  DocumentSnapshot? _lastDocument;
  List<PetModel> get pets => _pets;
  List<PetModel> get adoptedPets => _adoptedPets;
  bool _hasMorePets = true;
  bool get hasMorePets => _hasMorePets;

  // void setupRealTimeUpdates() {
  //   FirebaseFirestore.instance
  //       .collection('pets')
  //       .snapshots()
  //       .listen((snapshot) {
  //     final petsData = snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       final id = doc.id;
  //       return PetModel(
  //         id: id,
  //         age: data['age'],
  //         name: data['name'],
  //         breed: data['breed'],
  //         price: data['price'],
  //         isSold: data['isSold'],
  //         imageLink: data['imageLink'],
  //       );
  //     }).toList();
  //
  //     _pets = petsData;
  //
  //     notifyListeners();
  //   });
  // }




  Future<void> fetchAdoptedPets() async {
    try {
      final query = FirebaseFirestore.instance
          .collection('pets')
          .where('isSold', isEqualTo: true);

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
      // Handle the error gracefully
    }
  }

  Future<void> fetchInitialPets() async {
    try {
      final query = FirebaseFirestore.instance
          .collection('pets')
          .limit(_batchSize);

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

      // final snapshot = await query.get();
      //
      // final petsData = snapshot.docs.map((doc) {
      //   final data = doc.data();
      //   final id = doc.id;
      //   return PetModel(
      //     id: id,
      //     age: data['age'],
      //     name: data['name'],
      //     breed: data['breed'],
      //     price: data['price'],
      //     isSold: data['isSold'],
      //     imageLink: data['imageLink'],
      //     timestampOfAdoption: data['timestampOfAdoption']??="",
      //
      //   );
      // }).toList();

      _pets = petsData;
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      _hasMorePets = snapshot.docs.length == _batchSize;
      notifyListeners();});
    } catch (error) {
      // Handle the error gracefully
    }
  }


  Future<void> fetchNextPets() async {


    try {
      if (_lastDocument != null) {
        final query = FirebaseFirestore.instance
            .collection('pets')
            .startAfterDocument(_lastDocument!) // Add this line
            .limit(_batchSize);

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

          _pets.addAll(petsData);
          _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
          notifyListeners();
        });
      }
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

      final petIndex = _pets.indexWhere((pet) => pet.id == petId);
      if (petIndex != -1) {
        _pets[petIndex] = updatedPet!;
      }

      notifyListeners();

      // Perform any additional operations or state updates if needed
    } catch (error) {
      // Handle the error gracefully
    }
  }
}

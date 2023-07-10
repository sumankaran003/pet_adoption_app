class PetModel {
  final String id;
  final int age;
  final String name;
  final String breed;
  final double price;
  final bool isSold;
  final String imageLink;
  final String timestampOfAdoption;

  PetModel(
      {required this.age,
      required this.name,
      required this.breed,
      required this.price,
      required this.isSold,
      required this.imageLink,
      required this.id,
      required this.timestampOfAdoption});
}

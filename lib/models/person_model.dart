class Person {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String birthDay;
  final String gender;
  final String address;
  final String website;
  final String imageUrl;

  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDay,
    required this.gender,
    required this.address,
    required this.website,
    required this.imageUrl,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    String address = [
      json['address']['street'],
      json['address']['streetName'],
      json['address']['buildingNumber'],
      json['address']['city'],
      json['address']['zipcode'],
      json['address']['country'],
    ].join(', ');
    return Person(
      id: json['id'],
      name: json['firstname'] + ' ' + json['lastname'],
      email: json['email'],
      phone: json['phone'],
      birthDay: json['birthday'],
      gender: json['gender'],
      address: address,
      website: json['website'],
      imageUrl: json['image'],
    );
  }
}

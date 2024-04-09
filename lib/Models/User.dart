class Patient {
  String uid;
  String bloodGroup;
  String city;
  String contactNo;
  String firstName;
  String lastName;
String email;
  String displayName;
  DateTime dob;

  String gender;

  String profileImage;
  int age;

  Patient({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.bloodGroup,
    required this.city,
    required this.contactNo,
    required this.displayName,
    required this.dob,

    required this.gender,

    required this.profileImage,
    required this.age,
  });
}

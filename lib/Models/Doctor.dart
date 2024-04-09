class Doctor {
  final String uniqueIdentifier;
  final String firstName;
  final String lastName;
  final String category;
  final String gender;
  final String email;
  final String iban;
  final String phone;
  final String doctorAbout;
  final String profilePic;

  Doctor({
    required this.uniqueIdentifier,
    required this.doctorAbout,
    required this.firstName,
    required this.lastName,
    required this.category,
    required this.gender,
    required this.iban,
    required this.phone,
    required this.email,
    required this.profilePic,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final doctorData = json['doctorData'] as Map<String, dynamic>; // Access doctorData object

    return Doctor(
      uniqueIdentifier: doctorData['uniqueIdentifier'] ?? '',
      doctorAbout: doctorData['doctorAbout'] ?? '',
      firstName: doctorData['firstName'] ?? '',
      lastName: doctorData['lastName'] ?? '',
      category: doctorData['category'] ?? '',
      gender: doctorData['gender'] ?? '',
      profilePic: doctorData['profilePic'] ?? '', // Handle null profileImageUrl
      iban: doctorData['iban'] ?? '',
      phone: doctorData['phone'] ?? '',
      email: doctorData['email'] ?? '',
    );
  }


}

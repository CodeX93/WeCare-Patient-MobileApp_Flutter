import '../Models/Doctor.dart';

class Filter {
  String? specialization;
  String? departmentName;
  String? fee;
  String? gender;

  Filter({this.specialization});

  bool applyFilters(Doctor doctor) {
    // Print doctor's category for debugging
    print('Doctor category: ${doctor.category}');

    // Check specialization filter (case-insensitive, exact match)
    bool specializationMatches = specialization == null ||
        doctor.category.toLowerCase() == specialization!.toLowerCase();

    // Print whether specialization matches for debugging
    print('Specialization matches: $specializationMatches');

    // Check other filters as needed

    return specializationMatches;
  }
}

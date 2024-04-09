class Department {
  final String id;
  final String selectedIcon;
  final String email;
  final String description;
  final String coverImageURL;
  final String head;
  final String hospitalName;
  final int staffCount;
  final String phone;
  final String name;

  Department({
    required this.id,
    required this.selectedIcon,
    required this.email,
    required this.description,
    required this.coverImageURL,
    required this.head,
    required this.hospitalName,
    required this.staffCount,
    required this.phone,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? '',
      selectedIcon: json['selectedIcon'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      coverImageURL: json['coverImageURL'] ?? '',
      head: json['head'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      staffCount: json['staffCount'] is String ? int.tryParse(json['staffCount']) ?? 0 : json['staffCount'] ?? 0,
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

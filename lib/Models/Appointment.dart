class Appointment {
  final int fee;
  final String doctorId;
  final String doctorName;
  final String department;
  final String complain;
  final String slot;
  final String date;
  final String patientId;
  final String slotId;
  final String patientName;
  final String profileImage;
  final String type; // Add the type property
  final String meetingLink; // Add the meetingLink property
  final String hospital; // Add the hospital property
  final String email; // Add the email property

  Appointment({
    required this.fee,
    required this.doctorId,
    required this.doctorName,
    required this.department,
    required this.complain,
    required this.slot,
    required this.date,
    required this.patientId,
    required this.slotId,
    required this.patientName,
    required this.profileImage,
    required this.type, // Initialize the type property
    required this.meetingLink, // Initialize the meetingLink property
    required this.hospital, // Initialize the hospital property
    required this.email, // Initialize the email property
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      fee: json['fee'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      department: json['department'],
      complain: json['complain'],
      slot: json['slot'],
      date: json['date'],
      patientId: json['patientId'],
      slotId: json['slotId'],
      patientName: json['patientName'],
      profileImage: json['profileImage'],
      type: json['type'], // Initialize the type property
      meetingLink: json['meetingLink'], // Initialize the meetingLink property
      hospital: json['hospital'], // Initialize the hospital property
      email: json['email'], // Initialize the email property
    );
  }
}

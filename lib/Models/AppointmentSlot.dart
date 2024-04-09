// DoctorAppointmentSlot model
class DoctorAppointmentSlot {
  final String weekStartDate;
  final List<AvailabilitySlot> availabilitySlots;

  DoctorAppointmentSlot({
    required this.weekStartDate,
    required this.availabilitySlots,
  });

  factory DoctorAppointmentSlot.fromJson(Map<String, dynamic> json) {
    List<AvailabilitySlot> availabilitySlots = (json['availabilitySlots'] as List)
        .map((slotJson) => AvailabilitySlot.fromJson(slotJson))
        .toList();

    return DoctorAppointmentSlot(
      weekStartDate: json['weekStartDate'],
      availabilitySlots: availabilitySlots,
    );
  }
}

// AvailabilitySlot model
class AvailabilitySlot {
  final String date;
  final List<DetailedSlot> detailedSlots;

  AvailabilitySlot({
    required this.date,
    required this.detailedSlots,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    List<DetailedSlot> detailedSlots = (json['detailedSlots'] as List)
        .map((detailedSlotJson) => DetailedSlot.fromJson(detailedSlotJson))
        .toList();

    return AvailabilitySlot(
      date: json['date'],
      detailedSlots: detailedSlots,
    );
  }
}

// DetailedSlot model
class DetailedSlot {
  final String uuid;
  final String startTime;
  final String endTime;
  final String slotType;
  final int price;
  final String hospital;
  final String location;
  final String appointmentLink;
  final String availability;

  DetailedSlot({
    required this.uuid,
    required this.startTime,
    required this.endTime,
    required this.slotType,
    required this.price,
    required this.hospital,
    required this.location,
    required this.appointmentLink,
    required this.availability,
  });

  factory DetailedSlot.fromJson(Map<String, dynamic> json) {
    return DetailedSlot(
      uuid: json['uuid'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      slotType: json['slotType'],
      price: json['price'],
      hospital: json['hospital'],
      location: json['location'],
      appointmentLink: json['appointmentLink'],
      availability: json['availability'],
    );
  }
}

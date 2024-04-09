import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecord {
  String patientId;
  String id;
  String recordType;
  String? fileUrl; // Now optional
  DateTime date;
  String? comments;
  bool isVisibleToDoctor;
  Map<String, dynamic>? content; // For textual prescriptions

  MedicalRecord({
    this.id='',
    this.patientId = '',
    required this.recordType,
    this.fileUrl,
    required this.date,
    this.comments,
    this.isVisibleToDoctor = false,
    this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'recordType': recordType,
      'fileUrl': fileUrl,
      'date': date,
      'comments': comments,
      'isVisibleToDoctor': isVisibleToDoctor,
      'content': content, // Add content to Firestore as well
    };
  }

  static MedicalRecord fromMap(Map<String, dynamic> map, String documentId) {
    return MedicalRecord(
      id: documentId,

      recordType: map['recordType'],
      fileUrl: map['fileUrl'] as String?,
      date: (map['date'] as Timestamp).toDate(),
      comments: map['comments'],
      isVisibleToDoctor: map['isVisibleToDoctor'],
      content: map['content'] as Map<String, dynamic>?,
    );
  }
}

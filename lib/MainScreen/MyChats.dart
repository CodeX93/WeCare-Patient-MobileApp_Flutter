import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomScreenAppBar(
        title: 'My Chats',
      ),
    );
  }
}

import 'dart:convert';

import 'package:daily_flutter/daily_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wecare_patient_mobile/Util/constant.dart';

class CallingScreen extends StatefulWidget {
  final String callingId;
  final CallClient client;

  const CallingScreen({
    Key? key,
    required this.callingId,
    required this.client,
  }) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  late final VideoViewController _controller;
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();

    _controller = VideoViewController();
    initCall();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initCall() async {
    try {
      // Fetch token
      final token = await fetchToken(widget.callingId);
      print(token); // Print token for verification

      // Join the call with CallConfig
      Uri url = Uri.parse(widget.callingId);

      await widget.client.join(
        url: url,
        token: token,

      );

      // Call initialized, set isLoading to false
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error initializing call: $e');
    }
  }


  Future<String> fetchToken(String meetingLink) async {
    try {
      // Extract room name from the meeting link
      final roomName = meetingLink.split("/").last;

      // Fetch token from backend
      final response = await http.post(
        Uri.parse("http://${Constant.IP}:5002/api/meeting/generateToken"),
        body: {'roomName': roomName},
      );

      // Parse JSON response
      final jsonResponse = json.decode(response.body);

      // Extract token value
      final token = jsonResponse['token'];

      // Return the token string
      return token;
    } catch (e) {
      // Handle error
      print('Error fetching token: $e');
      return ''; // Return an empty string in case of error
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: VideoView(controller: _controller),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

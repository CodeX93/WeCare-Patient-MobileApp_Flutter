import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../Functions/Firebase/AuthReg.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
   FirebaseService firebaseService = FirebaseService();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _cityController;
  late TextEditingController _contactNoController;
  File? _image;

  late DateTime _selectedDate = DateTime.now();

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _dobController = TextEditingController();
    _genderController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _cityController = TextEditingController();
    _contactNoController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
    _cityController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Green color theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image.asset('assets/images/signup.png'),
            GestureDetector(
              onTap: () {
                _getImage();
              },
              child: _image != null
                  ? Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : const CircleAvatar(
                radius: 50, // Adjust the radius according to your preference
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ), // Placeholder image
            ),


            const SizedBox(height: 15),


            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: _genderController.text.isNotEmpty
                  ? _genderController.text
                  : null,
              items: genders.map((String gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _genderController.text = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: _bloodGroupController.text.isNotEmpty
                  ? _bloodGroupController.text
                  : null,
              items: bloodGroups.map((String bloodGroup) {
                return DropdownMenuItem(
                  value: bloodGroup,
                  child: Text(bloodGroup),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _bloodGroupController.text = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Blood Group',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contactNoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(

                labelText: 'Contact Number',
              ),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 20.0),
            ElevatedButton(

              onPressed: () async {
                if (_passwordController.text == _confirmPasswordController.text) {
                  try {
                    String message = await firebaseService.signUpAndUploadProfile(
                      email: _emailController.text,
                      password: _passwordController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      gender: _genderController.text,
                      dob: _selectedDate,
                      bloodGroup: _bloodGroupController.text,
                      city: _cityController.text,
                      contactNo: _contactNoController.text,
                      profileImage: _image,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green button color
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white, letterSpacing: 1.5),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }



  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  bool _isProfileUpdated = false;
  String? _profileImageUrl;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _firebaseUser;

  @override
  void initState() {
    super.initState();
    _firebaseUser = _auth.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    if (_firebaseUser != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_firebaseUser!.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _dobController.text = data['dob'] ?? '';
        _contactNoController.text = data['contactNo'] ?? '';
        _cityController.text = data['city'] ?? '';
        _profileImageUrl = data['profileImage'];
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    String? imageUrl = _profileImageUrl;

    if (_profileImage != null) {
      String fileName = 'profile_${_firebaseUser!.uid}.jpg';
      File file = File(_profileImage!.path);
      try {
        TaskSnapshot snapshot =
        await _storage.ref('profile_images/$fileName').putFile(file);
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print(e); // Handle errors of image upload if any
      }
    }

    if (_firebaseUser != null) {
      await _firestore.collection('users').doc(_firebaseUser!.uid).update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'dob': _dobController.text,
        'contactNo': _contactNoController.text,
        'city': _cityController.text,
        'profileImage': imageUrl
      });

      setState(() {
        _isLoading = false;
        _isProfileUpdated = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  Future<void> _chooseProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _isProfileUpdated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
        actions: [
          if (_isProfileUpdated)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _updateProfile,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _chooseProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : (_profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : const AssetImage('assets/images/default_profile.png'))
                as ImageProvider,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(_firstNameController, 'First Name'),
            _buildTextField(_lastNameController, 'Last Name'),
            _buildTextField(
              _dobController,
              'Date of Birth',
              readOnly: true,
              onTap: () => _selectDOB(context),
            ),
            _buildTextField(_contactNoController, 'Phone'),
            _buildTextField(_cityController, 'City'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProfileUpdated ? _updateProfile : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _isProfileUpdated ? Colors.teal : Colors.grey,
              ),
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => setState(() => _isProfileUpdated = true),
      ),
    );
  }

  Future<void> _selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toLocal().toString().split(' ')[0];
        _isProfileUpdated = true;
      });
    }
  }
}

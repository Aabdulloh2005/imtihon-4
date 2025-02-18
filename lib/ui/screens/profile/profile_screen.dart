import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro_app/services/user_auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = UserAuthService();
  String username = '';
  File? _image;
  String? photoUrl;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    await Future.delayed(Duration(seconds: 1));
    if (_currentUser != null) {
      try {
        DocumentSnapshot user =
            await _authService.getUserInfo(_currentUser!.uid);
        // if (mounted) {
        setState(() {
          username = user['userName'] ?? '';
          photoUrl = user['imageurl'];
        });
        // }
      } catch (e) {
        // Handle error if necessary
        print('Error loading user information: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        String? downloadUrl =
            await _authService.uploadProfileImage(_image!, _currentUser!.uid);
        if (downloadUrl != null) {
          setState(() {
            photoUrl = downloadUrl;
          });

          await _authService.updateProfile(_currentUser!.uid, username,
              photoUrl: photoUrl);
        }
      } catch (e) {
        // Handle error if necessary
        print('Error uploading profile image: $e');
      }
    }
  }

  Future<void> _editUsername() async {
    final TextEditingController _controller =
        TextEditingController(text: username);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Enter new username"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    username = _controller.text;
                  });
                  try {
                    await _authService.updateProfile(
                        _currentUser!.uid, username);
                  } catch (e) {
                    // Handle error if necessary
                    print('Error updating username: $e');
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editUsername,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 120,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (photoUrl != null && photoUrl!.isNotEmpty
                          ? NetworkImage(photoUrl!)
                          : null),
                  child:
                      _image == null && (photoUrl == null || photoUrl!.isEmpty)
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                ),
              ),
              const Gap(20),
              Text(username),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ass1/components/button.dart';
import 'package:ass1/components/textfield.dart';
import '../database/database_helper.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({super.key, required this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController studentIdController;
  late TextEditingController passwordController;
  String? gender;
  int? selectedLevel;
  File? image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    studentIdController = TextEditingController(
      text: widget.userData['studentId'],
    );
    passwordController = TextEditingController(
      text: widget.userData['password'],
    );
    gender = widget.userData['gender'];
    selectedLevel = widget.userData['level'];
    image =
        widget.userData['image'] != null
            ? File(widget.userData['image'])
            : null;
      
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  bool validateInputs() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String studentId = studentIdController.text.trim();
    String password = passwordController.text.trim();

    String fciEmailPattern = r"^[0-9]{8}@stud\.fci-cu\.edu\.eg$";
    bool isValidEmail = RegExp(fciEmailPattern).hasMatch(email);
    bool isValidStudentId = RegExp(r"^\d{8}$").hasMatch(studentId);

    if (name.isEmpty) {
      showMessage("Name cannot be empty.");
      return false;
    } else if (!isValidEmail) {
      showMessage("Invalid FCI email format.");
      return false;
    } else if (!isValidStudentId) {
      showMessage("Student ID must be exactly 8 digits.");
      return false;
    } else if (password.length < 6) {
      showMessage("Password must be at least 6 characters.");
      return false;
    }

    return true;
  }

  void updateUserProfile() async {
    if (!validateInputs()) return;

    DatabaseHelper dbHelper = DatabaseHelper();
    int updatedRows = await dbHelper.updateUser(widget.userData['id'], {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'studentId': studentIdController.text.trim(),
      'password': passwordController.text.trim(),
      'gender': gender,
      'level': selectedLevel,
      'image': image?.path,
    });

    if (updatedRows > 0) {
      showMessage("Profile Updated Successfully!", isSuccess: true);
    } else {
      showMessage("Update Failed.");
    }
  }

  void showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
                  child: image == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: studentIdController,
                hintText: 'Student ID',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    const Text("Gender: "),
                    Radio<String>(
                      value: "Male",
                      groupValue: gender,
                      onChanged: (value) => setState(() => gender = value),
                    ),
                    const Text("Male"),
                    Radio<String>(
                      value: "Female",
                      groupValue: gender,
                      onChanged: (value) => setState(() => gender = value),
                    ),
                    const Text("Female"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButton<int>(
                  value: selectedLevel,
                  hint: const Text("Select Level"),
                  items:
                      [1, 2, 3, 4]
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text("Level $level"),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => selectedLevel = value),
                  isExpanded: true,
                ),
              ),

              const SizedBox(height: 20),

              MyButton(onTap: updateUserProfile, text: "Update Profile"),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ass1/components/button.dart';
import 'package:ass1/components/textfield.dart';
import '../database/database_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? gender;
  int? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),
                Text(
                  'Welcome To Sign Up Page!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
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
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Text("Gender: "),
                      Radio<String>(
                        value: "Male",
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      Text("Male"),
                      Radio<String>(
                        value: "Female",
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      Text("Female"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DropdownButton<int>(
                    value: selectedLevel,
                    hint: Text("Select Level"),
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
                const SizedBox(height: 25),
                MyButton(onTap: () => signUserUp(context), text: "Sign Up"),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUserUp(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String studentId = studentIdController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    String emailPattern = r'^\d+@stud\.fci-cu\.edu\.eg$';
    RegExp emailRegex = RegExp(emailPattern);
    bool isEmailValid = emailRegex.hasMatch(email.trim());
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool isPasswordValid = password.length >= 8 && hasNumber;
    RegExp studentIdRegex = RegExp(r'^\d+$');
    bool isStudentIdValid = studentIdRegex.hasMatch(studentId.trim());

    if ([
      name,
      email,
      studentId,
      password,
      confirmPassword,
    ].any((e) => e.isEmpty)) {
      showMessage(context, 'Please fill all fields', Colors.red);
    } else if (!isEmailValid) {
      showMessage(context, 'Invalid email format', Colors.red);
    } else if (!isStudentIdValid || !email.startsWith(studentId)) {
      showMessage(context, 'Student ID mismatch with email', Colors.red);
    } else if (!isPasswordValid) {
      showMessage(
        context,
        'Password must be 8+ chars with a number',
        Colors.red,
      );
    } else if (password != confirmPassword) {
      showMessage(context, 'Passwords do not match', Colors.red);
    } else {
      DatabaseHelper dbHelper = DatabaseHelper();
      Map<String, dynamic>? existingUser = await dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        showMessage(context, 'User already exists', Colors.red);
        return;
      }
      int userId = await dbHelper.insertUser({
        'name': name,
        'email': email,
        'studentId': studentId,
        'password': password,
        'gender' : gender,
        'level' : selectedLevel,
      });
      if (userId > 0) {
        showMessage(context, 'Signup Successful!', Colors.green);
      } else {
        showMessage(context, 'Signup Failed!', Colors.red);
      }
    }
  }

  void showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

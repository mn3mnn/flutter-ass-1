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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(Icons.lock, size: 100),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome To Sign Up Page!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                const SizedBox(height: 25),

                // name textfield
                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // student id field
                MyTextField(
                  controller: studentIdController,
                  hintText: 'Student ID',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: false,
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
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text("Male"),
                      Radio<String>(
                        value: "Female",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text("Female"),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DropdownButton<int>(
                    value: selectedLevel,
                    // width: screenWidth /4,
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

                // sign in button
                MyButton(onTap: () => signUserUp(context), text: "Sign Up"),

                const SizedBox(height: 50),

                // already a member? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
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
  // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? gender;
  int? selectedLevel;

  void signUserUp(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String studentId = studentIdController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    String emailPattern =
        r'^\d+@stud\.fci-cu\.edu\.eg$'; //123456@stud.fci-cu.edu.eg
    RegExp emailRegex = RegExp(emailPattern);
    bool isEmailValid = emailRegex.hasMatch(email.trim());

    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool isPasswordValid = password.length >= 8 && hasNumber;

    RegExp studentIdRegex = RegExp(r'^\d+$');
    bool isStudentIdValid = studentIdRegex.hasMatch(studentId.trim());

    if (name.isEmpty ||
        email.isEmpty ||
        studentId.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid email address, email should be in the form of your student id followed by @stud.fci-cu.edu.eg',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!isStudentIdValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid student id'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!email.startsWith(studentId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email must start with your student id'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password must be at least 8 characters and contain a number',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up successful'),
          backgroundColor: Colors.green,
        ),
      );
    }

  DatabaseHelper dbHelper = DatabaseHelper();

  void testFetchUsers() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> users = await dbHelper.getAllUsers();

    print("Users in DB: $users"); // ✅ Debugging Log
  }

  Map<String, dynamic>? existingUser = await dbHelper.getUserByEmail(email);
  if (existingUser != null) {
    showMessage(context, "User already exists with this email.");
    return;
  }

  int userId = await dbHelper.insertUser({
    'name': name,
    'email': email,
    'studentId': studentId,
    'password': password, // In production, hash the password
  });

  if (userId > 0) {
    showMessage(context, "Signup Successful!");
    testFetchUsers();
  } else {
    showMessage(context, "Signup Failed!");
  }
}



  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message == "Signup Successful!" ? Colors.green : Colors.red,
      ),
    );
  }

  

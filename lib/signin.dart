import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';  // Assuming this is your home page or dashboard after login
// If you need to navigate to signup from login

final _firebase = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var enteredEmail = "";
  var enteredPassword = "";
  final _isLogin = true; // Toggle between login/signup
  final formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    try {
      if (_isLogin) {
        // Login
        await _firebase.signInWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PondDataScreen()), // Navigate to the dashboard after login
        );
      } 
    } catch (error) {
      String errorMessage = "An error occurred. Please try again later.";
      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          errorMessage = 'The email is already in use by another account.';
        } else if (error.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (error.code == 'wrong-password') {
          errorMessage = 'Incorrect password entered.';
        }
      }
      // Show error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Authentication Failed'),
          content: const Text("Please enter a valid credentials"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image 1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 270, left: 35),
              child: Text(
                'Username',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 300, left: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: 300,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || !value.contains('@')) {
                      return 'Please enter a valid address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredEmail = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 350, left: 35),
              child: Text(
                'Password',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 380, left: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: 300,
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredPassword = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 480, left: 110),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.black,
                ),
                onPressed: _submitForm, // Check email and password when pressed
                child: const Text("Log in",style: TextStyle(color: Color.fromARGB(255, 203, 199, 199)),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 570, left: 110),
              child: TextButton(
                onPressed: () {
                  // Toggle between login and sign-up mode
                },
                child: const Text("Forgrt password?"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

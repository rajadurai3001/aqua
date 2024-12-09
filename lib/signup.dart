import 'package:aquaculture/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SignupState();
}

class _SignupState extends State<Signin> {
  var enteredphno = "";
  var enteredemail = "";
  var enteredpassword = "";
  var systemscount = "";
  var _islogin = false;
  final formkey = GlobalKey<FormState>();

  void submit() async {
    final isvalid = formkey.currentState!.validate();

    if (!isvalid) {
      return;
    }

    formkey.currentState!.save();
    if (_islogin) {
      // Login users if the flag is true (currently not implemented in your code)
    } else {
      try {
        final usercredentials = await _firebase.createUserWithEmailAndPassword(
          email: enteredemail,
          password: enteredpassword,
        );
        _islogin = true;

        // After successful registration, show success message and proceed to dashboard
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully Registered!"),
            backgroundColor: Colors.green,
          ),
        );

        // Redirect to the dashboard or another page
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PondDataScreen()));

      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          // If email is already in use, show the appropriate message
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This email is already in use."),
              backgroundColor: Color.fromARGB(255, 231, 128, 121),
            ),
          );
        } else {
          // Handle other errors if necessary
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message ?? 'Authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Stack(
          children: [
             Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/image.jpg'))
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 150, left: 35),
              child: Text(
                'Phone number',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180, left: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: 200,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return 'Must have 10 digits';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredphno = value!;
                  },
                  decoration: InputDecoration(
                    labelText: '+91|',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 250, left: 35),
              child: Text(
                'Username',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 280, left: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: 200,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || !value.contains('@')) {
                      return 'Please enter a valid address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredemail = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter a username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 350, left: 35),
              child: Text(
                'Password',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 380, left: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: 200,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredpassword = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 450, left: 35),
              child: Text(
                'Number of systems needed',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 490, left: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: 200,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a value';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Enter a number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    systemscount = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'XXXXX',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 600, left: 110),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.black,
                ),
                onPressed: submit,
                child: const Text(
                  "Sign in",
                  style: TextStyle(color: Color.fromARGB(255, 195, 192, 192)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:aquaculture/signin.dart';
import 'package:aquaculture/signup.dart';
import 'package:flutter/material.dart';
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/image.jpg'))
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 80,left: 120),
              child: Text("Splash",style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 231, 229, 229),
                fontFamily: 'San Francisco'
              ),),
            ),
             const Padding(
              padding: EdgeInsets.only(top: 140,left: 70),
              child: Text("WATER MONITORING IN YOUR HAND",style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 231, 229, 229),
                fontFamily: 'San Francisco'
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 500,left: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200,60),
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor:Colors.black
                ),onPressed: (){
                   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const Signup()),
            );
                }, child:const Text('Log in',style: TextStyle(color: Color.fromARGB(255, 188, 184, 184)),)),
            ), 
            Padding(
              padding: const EdgeInsets.only(top: 600,left: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200,60),
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor:Colors.black
                ),
                onPressed: (){
                   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const Signin()),
            );
                }, child:const Text('sign in',style:TextStyle(
                  color:Color.fromARGB(255, 188, 184, 184)
                ),)),
            )
          ],
        ),
      ),
    );
  }
}
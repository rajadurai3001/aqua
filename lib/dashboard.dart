import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PondDataScreen extends StatefulWidget {
  const PondDataScreen({super.key});

  @override
  _PondDataScreenState createState() => _PondDataScreenState();
}
class _PondDataScreenState extends State<PondDataScreen> {
  String selectedPond = " SELECT A POND";
  String userEmail = "";
  bool isEmailMatched = false;
  List<String> pondList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email ?? "";
      _checkUserEmail();
      _fetchPondList();
    }
  }

  Future<void> _checkUserEmail() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
      setState(() {
        isEmailMatched = userDoc.exists;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isEmailMatched = false;
        isLoading = false;
      });
      print('Error checking user email: $e');
    }
  }

  Future<void> _fetchPondList() async {
    try {
      setState(() {
        isLoading = true;
      });
      var pondDocs = await FirebaseFirestore.instance.collection('ponds').get();
      List<String> pondNames = [];
      for (var doc in pondDocs.docs) {
        pondNames.add(doc.id);
      }
      setState(() {
        pondList = pondNames;
        selectedPond = pondNames.isNotEmpty ? pondNames[0] : "";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching ponds: $e');
    }
  }

  // Function to determine which image to show based on temperature
  Widget _getTemperatureImage(double temperature) {
    if (temperature > 30) {
      return Image.asset('assets/temp red.jpg',height: 100,width: 100,); // Danger image for high temperature
    } else if (temperature >= 20 && temperature <= 30) {
      return Image.asset('assets/temp yellow.png',height: 100,width: 100,); // Average image for normal temperature
    } else {
      return Image.asset('assets/temp green.jpg',height: 100,width: 100,); // Below average image for low temperature
    }
  }

  // Function to determine which image to show based on pH level
  Widget _getPhImage(double pH) {
    if (pH > 8.0) {
      return Image.asset('assets/red beaker.jpg',height: 100,width: 100,); // Danger image for high pH
    } else if (pH >= 6.5 && pH <= 8.0) {
      return Image.asset('assets/yellow beaker.jpg',height: 100,width: 100,); // Average image for normal pH
    } else {
      return Image.asset('assets/green beaker.jpg',height: 100,width: 100,); // Below average image for low pH
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/homepage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 55, left: 110),
            child: Text(
              "Dashboard",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 20),
            child: DropdownButton<String>(
              dropdownColor: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              value: selectedPond.isEmpty ? null : selectedPond,
              items: pondList.map((pond) {
                return DropdownMenuItem<String>(
                  value: pond,
                  child: Text(pond),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPond = value!;
                });
              },
              hint: const Text("Select a Pond"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isEmailMatched
                    ? StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('ponds')
                            .doc(selectedPond)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Center(child: Text('No data available for this pond'));
                          }

                          var pondData = snapshot.data!.data() as Map<String, dynamic>;

                          // Convert 'temperature' and 'pH' to double safely
                        double temperature = double.tryParse(pondData['temperature'].toString()) ?? 0.0;
                        double pH = double.tryParse(pondData['pH'].toString()) ?? 0.0;


                          return GridView.count(
                            crossAxisCount: 2,
                            padding: const EdgeInsets.all(8.0),
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            children: [
                              // Show temperature value and corresponding image
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Temperature: ${temperature}°C',
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    _getTemperatureImage(temperature), // Temperature image
                                  ],
                                ),
                              ),
                              // Show pH value and corresponding image
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'pH Level: ${pH}',
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    _getPhImage(pH), // pH image
                                  ],
                                ),
                              ),
                               Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'pH Level: ${pH}',
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    _getPhImage(pH), // pH image
                                  ],
                                ),
                              ),
                               Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'pH Level: ${pH}',
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    _getPhImage(pH), // pH image
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : const Center(child: Text('No data available or email mismatch')),
          ),
        ],
      ),
    );
  }
}

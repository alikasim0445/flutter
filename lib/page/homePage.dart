import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> userData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('user').get();
      final List<Map<String, dynamic>> fetchedData = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'firstName': data['first name'] ?? 'N/A',
          'lastName': data['last name'] ?? 'N/A',
          'age': data['age'] ?? 'N/A',
        };
      }).toList();

      setState(() {
        userData = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user data: $e");
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("${user?.email ?? 'User'}"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userData.isEmpty
              ? Center(
                  child: Text('No user data available'),
                )
              : ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final user = userData[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          "${user['firstName']} ${user['lastName']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Age: ${user['age']}"),
                      ),
                    );
                  },
                ),
    );
  }
}

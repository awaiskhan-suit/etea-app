import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';
import 'package:etea/show_rollno.dart';
import 'package:etea/student_marks.dart';
import 'package:etea/student_rollno.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RollNoPage());
}

class RollNoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: RollNoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RollNoScreen extends StatelessWidget {
  final cnic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          // ✅ you must wrap all widgets in children: []
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                "Khyber Pakhtunkhwa",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Educational Testing & Evaluation Agency",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "TEST ROLL NUMBER SLIP",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red[900]),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: cnic,
                decoration: InputDecoration(
                  hintText: 'Enter Your CNIC without dashes',
                  prefixIcon: Icon(Icons.badge),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final enterCNIC = cnic.text.trim();
                  if (enterCNIC.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your CNIC")),
                    );
                    return;
                  }

                  // Assuming getStudentByCnic returns Future<Student?>
                  final Student? student =
                  await DBHelper.instance.getStudentByCnic(enterCNIC);

                  if (student != null) {
                    // Pass student to detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentRollNoScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid CNIC or student not found")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("SEARCH"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';
import 'package:etea/show_rollno.dart';
import 'package:etea/student_marks.dart';
import 'package:etea/student_rollno.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ResultPage());
}

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // 👇 use an existing widget here:
      home: StudentMarks(), // or ShowRollNo() or whatever your real result screen is
      debugShowCheckedModeBanner: false,
    );
  }
}

// 👇 renamed to avoid collision
class RollNoSearchScreen extends StatelessWidget {
  final cnic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            // ... all your widgets ...
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

                  final Student? student =
                  await DBHelper.instance.getStudentByCnic(enterCNIC);

                  if (student != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentMarks(), // your details page
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

import 'dart:io';
import 'package:etea/show_marks.dart';
import 'package:etea/show_rollno.dart';
import 'package:flutter/material.dart';
import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';

class StudentListScreen extends StatefulWidget {
  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = DBHelper.instance.getAllStudents();
  }

  void _refresh() {
    setState(() {
      _studentsFuture = DBHelper.instance.getAllStudents();
    });
  }

  void _assignRollNo(Student student) async {
    final controller = TextEditingController();
    final roll = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Assign Roll No"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter Roll No'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(ctx, int.parse(controller.text));
              } else {
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
    if (roll != null) {
      await DBHelper.instance.assignRollNo(student.id!, roll);
      _refresh();
    }
  }

  void _assignMarks(Student student) async {
    final controller = TextEditingController();
    final mark = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Assign Test Marks"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter Test Marks'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(ctx, int.parse(controller.text));
              } else {
                Navigator.pop(ctx);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
    if (mark != null) {
      await DBHelper.instance.assignTestMarks(student.id!, mark);
      _refresh();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Students")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: _studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No students found"));
                } else {
                  final students = snapshot.data!;
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final stu = students[index];
                      return Card(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: (stu.imagePath.isNotEmpty)
                                ? FileImage(File(stu.imagePath))
                                : null,
                            child: stu.imagePath.isEmpty
                                ? const Icon(Icons.person, size: 30)
                                : null,
                          ),
                          title: Text(stu.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Assign Roll No',
                                onPressed: () => _assignRollNo(stu),
                              ),
                              IconButton(
                                icon: const Icon(Icons.grade),
                                tooltip: 'Assign Test Marks',
                                onPressed: () => _assignMarks(stu),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "Roll No: ${stu.rollNo ?? 'Not assigned'}\n"
                                "Test Marks: ${stu.testMarks ?? 'Not assigned'}\n"

                                "Mobile: ${stu.mobile}\n"
                                "Matric Marks: ${stu.marks}\n"
                                "District: ${stu.district}\n"
                                "Tehsil: ${stu.tehsil}\n"
                                "Blood Group: ${stu.bloodGroup}\n"
                                "DOB: ${stu.dob}\n"
                                "CNIC: ${stu.cnic}\n",
                          ),




                        ),


                      );


                    },


                  );



                }
              },
            ),
          ),

          // Buttons at bottom
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentDetailScreen()));
                  },
                  child: const Text("Roll No"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentDetailScreenMarks()));
                  },
                  child: const Text("Result"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

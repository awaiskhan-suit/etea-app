import 'dart:io';
import 'package:flutter/material.dart';
import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';

class StudentDetailScreenMarks extends StatefulWidget {
  @override
  State<StudentDetailScreenMarks> createState() =>
      _StudentDetailScreenMarksState();
}

class _StudentDetailScreenMarksState extends State<StudentDetailScreenMarks> {
  final _rollNoController = TextEditingController();
  Student? _student;

  // Fetch student by roll no
  Future<void> _fetchStudent() async {
    if (_rollNoController.text.trim().isEmpty) return;

    int rollNo = int.tryParse(_rollNoController.text.trim()) ?? -1;
    final student = await DBHelper.instance.getStudentByRollNo(rollNo);

    if (student != null) {
      setState(() {
        _student = student;
      });
    } else {
      setState(() {
        _student = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No student found for this Roll No")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Enter Roll No
            TextField(
              controller: _rollNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Roll No',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Search Student"),
            ),
            const SizedBox(height: 20),

            if (_student != null)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Details table
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Field")),
                            DataColumn(label: Text("Value")),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text("Roll No")),
                              DataCell(Text(
                                  _student!.rollNo != null ? _student!.rollNo.toString() : '')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Test Marks")),
                              DataCell(Text(_student!.testMarks != null
                                  ? _student!.testMarks.toString()
                                  : 'Not assigned')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Name")),
                              DataCell(Text(_student!.name)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Mobile")),
                              DataCell(Text(_student!.mobile)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Matric Marks")),
                              DataCell(Text(_student!.marks)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("District")),
                              DataCell(Text(_student!.district)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Tehsil")),
                              DataCell(Text(_student!.tehsil)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Blood Group")),
                              DataCell(Text(_student!.bloodGroup)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("DOB")),
                              DataCell(Text(_student!.dob)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("CNIC")),
                              DataCell(Text(_student!.cnic)),
                            ]),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),
                    // Right: Photo
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: (_student!.imagePath.isNotEmpty)
                              ? FileImage(File(_student!.imagePath))
                              : null,
                          child: _student!.imagePath.isEmpty
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Photo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

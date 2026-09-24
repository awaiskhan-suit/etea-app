import 'dart:io';
import 'package:etea/utils/pdf_helper.dart';
import 'package:flutter/material.dart';
import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';

class StudentDetailScreen extends StatefulWidget {
  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final _rollNoController = TextEditingController();
  Student? _student;
  int? _enteredRollNo;

  Future<void> _fetchStudent() async {
    if (_rollNoController.text.trim().isEmpty) return;

    int rollNo = int.tryParse(_rollNoController.text.trim()) ?? -1;

    final student = await DBHelper.instance.getStudentByRollNo(rollNo);

    if (student != null) {
      setState(() {
        _student = student;
        _enteredRollNo = rollNo;
      });
    } else {
      setState(() {
        _student = null;
        _enteredRollNo = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No student found for this Roll No")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Student by Roll No")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _rollNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Roll No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),

            if (_student != null && _student!.rollNo != null)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: table
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
                              DataCell(Text(_enteredRollNo.toString())),
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
                              const DataCell(Text("Marks")),
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
                    // Right side: photo
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

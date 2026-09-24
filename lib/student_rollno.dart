import 'dart:io';
import 'package:etea/utils/pdf_helper.dart';
import 'package:flutter/material.dart';
import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';

class StudentRollNoScreen extends StatefulWidget {
  @override
  State<StudentRollNoScreen> createState() => _StudentRollNoScreenState();
}

class _StudentRollNoScreenState extends State<StudentRollNoScreen> {
  final _mobileController = TextEditingController();
  Student? _student;
  String? _enteredMobile; // just for showing the searched mobile

  Future<void> _fetchStudent() async {
    final enteredText = _mobileController.text.trim();

    if (enteredText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter phone number")),
      );
      return;
    }

    final student = await DBHelper.instance.getStudentByMobile(enteredText);

    if (student != null) {
      setState(() {
        _student = student;
        _enteredMobile = enteredText; // ✅ fix here
      });
    } else {
      setState(() {
        _student = null;
        _enteredMobile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No student found for this Phone No")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Student by Phone No")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          m
          children: [
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Phone No',
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

            if (_student != null)
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
                              DataCell(Text(_student!.rollNo.toString())),
                              // ✅ real rollNo
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
// This button = PDF without test marks
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Download PDF (Basic)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_student != null) {
                  await PdfHelper.generateStudentPdfBasic(
                    _student!,
                    _student!.rollNo?.toString() ?? '',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No student selected')),
                  );
                }
              },
            ),


          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:etea/data/local/db_helper.dart';
import 'package:etea/data/local/student_class.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _marks = TextEditingController();
  final _district = TextEditingController();
  final _tehsil = TextEditingController();
  final _bloodGroup = TextEditingController();
  final _dob = TextEditingController();
  final _cnic = TextEditingController();


  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        rollNo: null, // no rollNo for student registration
        name: _name.text.trim(),

        mobile: _mobile.text.trim(),
        marks: _marks.text.trim(),
        district: _district.text.trim(),
        tehsil: _tehsil.text.trim(),
        bloodGroup: _bloodGroup.text.trim(),
        dob: _dob.text.trim(),
        cnic: _cnic.text.trim(),
        imagePath: _image?.path ?? '',
      );
      await DBHelper.instance.insertStudent(student);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful")),
      );

      _formKey.currentState!.reset();
      setState(() {
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? const Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              const SizedBox(height: 20),
              _field(_name, 'Name'),

              _field(_mobile, 'Mobile'),
              _field(_marks, 'Marks'),
              _field(_district, 'District'),
              _field(_tehsil, 'Tehsil'),
              _field(_bloodGroup, 'Blood Group'),
              _field(_dob, 'DOB'),
              _field(_cnic, 'CNIC'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                  foregroundColor: Colors.white,
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Enter $hint' : null,
      ),
    );
  }
}

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/local/student_class.dart';

class PdfHelper {
  /// PDF with rollNo + basic data (no test marks)
  static Future<void> generateStudentPdfBasic(
      Student student, String rollNo) async {
    final pdf = pw.Document();

    // load image if exists
    pw.ImageProvider? studentImage;
    if (student.imagePath.isNotEmpty && File(student.imagePath).existsSync()) {
      final imageBytes = await File(student.imagePath).readAsBytes();
      studentImage = pw.MemoryImage(imageBytes);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _header(studentImage),
            pw.SizedBox(height: 20),
            _buildRow('Roll No', rollNo),
            _buildRow('Name', student.name),
            _buildRow('Mobile', student.mobile),
            _buildRow('Marks', student.marks),
            _buildRow('District', student.district),
            _buildRow('Tehsil', student.tehsil),
            _buildRow('Blood Group', student.bloodGroup),
            _buildRow('DOB', student.dob),
            _buildRow('CNIC', student.cnic),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'student_$rollNo.pdf',
    );
  }

  /// PDF with rollNo + testMarks + user data
  static Future<void> generateStudentPdfWithMarks(
      Student student, String rollNo) async {
    final pdf = pw.Document();

    // load image if exists
    pw.ImageProvider? studentImage;
    if (student.imagePath.isNotEmpty && File(student.imagePath).existsSync()) {
      final imageBytes = await File(student.imagePath).readAsBytes();
      studentImage = pw.MemoryImage(imageBytes);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _header(studentImage),
            pw.SizedBox(height: 20),
            _buildRow('Roll No', rollNo),
            _buildRow('Entry Test Marks', student.testMarks?.toString() ?? '—'),
            _buildRow('Name', student.name),
            _buildRow('Mobile', student.mobile),
            _buildRow('Marks', student.marks),
            _buildRow('District', student.district),
            _buildRow('Tehsil', student.tehsil),
            _buildRow('Blood Group', student.bloodGroup),
            _buildRow('DOB', student.dob),
            _buildRow('CNIC', student.cnic),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'student_withmarks_$rollNo.pdf',
    );
  }

  /// header (title + photo)
  static pw.Widget _header(pw.ImageProvider? image) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Student Details',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (image != null)
          pw.Container(
            width: 100,
            height: 100,
            child: pw.Image(image, fit: pw.BoxFit.cover),
          ),
      ],
    );
  }

  /// field row builder
  static pw.Widget _buildRow(String field, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text(
            '$field: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(value),
        ],
      ),
    );
  }
}

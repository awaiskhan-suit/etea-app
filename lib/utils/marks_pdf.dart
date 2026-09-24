import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/local/student_class.dart';

class PdfHelper {
  /// Generate & show share/print dialog for the given student
  static Future<void> generateStudentMarksPdf(
      Student student, String rollNo) async {
    final pdf = pw.Document();

    // Try to load the image
    pw.ImageProvider? studentImage;
    if ((student.imagePath.isNotEmpty) &&
        File(student.imagePath).existsSync()) {
      final imageBytes = await File(student.imagePath).readAsBytes();
      studentImage = pw.MemoryImage(imageBytes);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Student Details',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (studentImage != null)
                  pw.Container(
                    width: 100,
                    height: 100,
                    child: pw.Image(studentImage, fit: pw.BoxFit.cover),
                  ),
              ],
            ),
            pw.SizedBox(height: 20),
            _buildRow('Roll No', rollNo),
            _buildRow(
                'Entry Test Marks', student.testMarks?.toString() ?? '—'),
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

    // Show system share/save dialog for PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'student_$rollNo.pdf',
    );
  }

  /// Save PDF to app's documents directory instead of sharing
  static Future<File> saveStudentMarksPdfLocally(
      Student student, String rollNo) async {
    final pdf = pw.Document();

    pw.ImageProvider? studentImage;
    if ((student.imagePath.isNotEmpty) &&
        File(student.imagePath).existsSync()) {
      final imageBytes = await File(student.imagePath).readAsBytes();
      studentImage = pw.MemoryImage(imageBytes);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Student Details for Roll No $rollNo',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            _buildRow('Name', student.name),
            _buildRow('Mobile', student.mobile),
            // … add more fields as needed …
          ],
        ),
      ),
    );

    // Save to app's documents directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/student_$rollNo.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

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

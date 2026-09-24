import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'student_class.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'etea.db');

    return await openDatabase(
      path,
      version: 2, // bumped to 2 so onUpgrade runs
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        // if coming from old version without test_marks
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE students ADD COLUMN test_marks INTEGER;');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rollNo INTEGER,
        testMarks INTEGER,
        name TEXT,
        mobile TEXT,
        marks TEXT,
        district TEXT,
        tehsil TEXT,
        bloodGroup TEXT,
        dob TEXT,
        cnic TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final res = await db.query('students');
    return res.map((e) => Student.fromMap(e)).toList();
  }

  Future<void> assignRollNo(int id, int rollNo) async {
    final db = await database;
    await db.update(
      'students',
      {'rollNo': rollNo},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> assignTestMarks(int id, int marks) async {
    final db = await database;
    return await db.update(
      'students',
      {'test_marks': marks},
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  Future<Student?> getStudentByRollNo(int rollNo) async {
    final db = await database;
    final res = await db.query(
      'students',
      where: 'rollNo = ?',
      whereArgs: [rollNo],
    );
    if (res.isNotEmpty) {
      return Student.fromMap(res.first);
    }
    return null;
  }

  Future<Student?> getStudentByCnic(String cnic) async {
    final db = await database;
    final res =
    await db.query('students', where: 'cnic = ?', whereArgs: [cnic]);
    if (res.isNotEmpty) {
      return Student.fromMap(res.first);
    }
    return null;
  }

  Future<Student?> getStudentByMobile(String mobile) async {
    final db = await database;
    final res = await db.query(
      'students',
      where: 'mobile = ?',
      whereArgs: [mobile],
    );
    if (res.isNotEmpty) {
      return Student.fromMap(res.first);
    }
    return null;
  }
}

class Student {
  final int? id;
  final int? rollNo;          // int because DB column is INTEGER
  final int? testMarks;       // int because DB column is INTEGER
  final String name;
  final String mobile;
  final String marks;
  final String district;
  final String tehsil;
  final String bloodGroup;
  final String dob;
  final String cnic;
  final String imagePath;

  Student({
    this.id,
    this.rollNo,
    this.testMarks,
    required this.name,
    required this.mobile,
    required this.marks,
    required this.district,
    required this.tehsil,
    required this.bloodGroup,
    required this.dob,
    required this.cnic,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rollNo': rollNo,
      'test_marks': testMarks,
      'name': name,
      'mobile': mobile,
      'marks': marks,
      'district': district,
      'tehsil': tehsil,
      'bloodGroup': bloodGroup,
      'dob': dob,
      'cnic': cnic,
      'imagePath': imagePath,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      rollNo: map['rollNo'] as int?,
      testMarks: map['test_marks'] as int?,
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      marks: map['marks'] ?? '',
      district: map['district'] ?? '',
      tehsil: map['tehsil'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      dob: map['dob'] ?? '',
      cnic: map['cnic'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }
}

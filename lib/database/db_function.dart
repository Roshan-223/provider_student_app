import 'package:flutter/material.dart';

import 'package:provider_students_detail/model/student.dart';
import 'package:sqflite/sqflite.dart';

DataBaseHelper dataBase=DataBaseHelper();
class DataBaseHelper{
  
ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

late Database _db;

Future<void> initializeDataBase() async {
  _db = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, age TEXT, place TEXT, mobile TEXT,image TEXT)');
    },
  );
  await getAllStudent();
}



Future<void> addStudent(StudentModel value) async {
 
  String image = value.imageurl ?? '';
  await _db.rawInsert(
      'INSERT INTO student(name,age,place,mobile,image) VALUES(?, ?, ?, ?, ?)',
      [value.name, value.age, value.place, value.mobile, image]);
      print('added successfully${value.name}');
  
  await getAllStudent();
}

Future<List<StudentModel>> getAllStudent() async {
  final values = await _db.rawQuery('SELECT * FROM student');
  studentListNotifier.value.clear();
  for (var map in values) {
    final user = StudentModel.fromMap(map);
    studentListNotifier.value.add(user);
     print('studentList is ${user.name}');
  }
 
  return studentListNotifier.value;
  


  // studentListNotifier.notifyListeners();

}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id=?', [id]);
 
  await getAllStudent();  
}

Future<void> updateStudent(StudentModel value) async {
  await _db.rawUpdate(
      'UPDATE student SET name = ?, age = ?, place = ?, mobile = ?, image = ? WHERE id = ?',
      [
        value.name,
        value.age,
        value.place,  
        value.mobile,
        value.imageurl,
        value.id
      ]);
 
  await getAllStudent();
}





}

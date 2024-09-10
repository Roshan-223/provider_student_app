import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider_students_detail/database/db_function.dart';
import 'package:provider_students_detail/model/student.dart';

class ControllerProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final placeController = TextEditingController();
  final mobilenumberController = TextEditingController();

  List<StudentModel> studentlist = [];
  File? selectedImage;

  void setImage(File image) {
    selectedImage = image;
    notifyListeners();
  }

  void addStudentFn(StudentModel student) {
    studentlist = [...studentlist, student];
    notifyListeners();
  }

  void studentUpdateFn(StudentModel student) {
    int index = studentlist.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      studentlist[index] = student;
      
      notifyListeners();
    }
  }

  Future<List<StudentModel>>getstudent()async {
     notifyListeners();
    return await dataBase.getAllStudent();
   
  }

   Future<void> deleteStudent(int id) async {
    
    int index = studentlist.indexWhere((student) => student.id == id);
    if (index != -1) {
    
      studentlist.removeAt(index);

      
      notifyListeners();

      
      await dataBase.deleteStudent(id);
    } else {
      print("Error: Student not found in the list");
    }
  }

}

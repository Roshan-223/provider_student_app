import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider_students_detail/controller_provider.dart';
import 'package:provider_students_detail/database/db_function.dart';
import 'package:provider_students_detail/model/student.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key, this.model});
  final StudentModel? model;

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    showData();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ControllerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Student'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              CircleAvatar(
                backgroundColor: Colors.black,
                maxRadius: 70,
                child: GestureDetector(
                  onTap: () async {
                    File? pickedImage = await _pickImageFromGallery();
                    if (pickedImage != null) {
                      controller.setImage(pickedImage);
                    }
                  },
                  child: controller.selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            controller.selectedImage!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        )
                      : const Icon(Icons.add_a_photo_rounded),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildTextField(
                      controller.nameController,
                      'Name',
                      TextInputType.name,
                      'Name is empty',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller.ageController,
                      'Age',
                      TextInputType.number,
                      'Enter a valid age',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller.placeController,
                      'Place',
                      TextInputType.text,
                      'Place is empty',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller.mobilenumberController,
                      'Mobile Number',
                      TextInputType.phone,
                      'Enter a valid 10-digit mobile number',
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        onAddStudentButtonClicked(context, model: widget.model);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showData() {
    if (widget.model != null) {
      final student = widget.model!;
      var controller = Provider.of<ControllerProvider>(context, listen: false); 
    //  var controller=(context).read<ControllerProvider>();
      controller.nameController.text = student.name!;
      controller.ageController.text = student.age!;
      controller.placeController.text = student.place!;
      controller.mobilenumberController.text = student.mobile!;
      controller.setImage(File(student.imageurl!));
    }
  }

  void onAddStudentButtonClicked(BuildContext context, {StudentModel? model}) {
    if (formKey.currentState!.validate()) {
      var controller = Provider.of<ControllerProvider>(context, listen: false);

      if (controller.selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Please select an image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      final student = StudentModel(
       id: model?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: controller.nameController.text,
        age: controller.ageController.text,
        place: controller.placeController.text,
        mobile: controller.mobilenumberController.text,
imageurl: controller.selectedImage?.path ?? model?.imageurl,      );

      if (model == null) {
        controller.addStudentFn(student);
        dataBase. addStudent(student);
      } else {
        controller.studentUpdateFn(student);
        dataBase.updateStudent(student);
      }
    
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Student saved successfully!'),
        ),
      );
    }
  }

  Future<File?> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Widget _buildTextField(TextEditingController controller, String hintText, TextInputType inputType, String validationMsg) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationMsg;
        }
        if (inputType == TextInputType.phone && value.length != 10) {
          return 'Enter a valid 10-digit mobile number';
        }
        return null;
      },
    );
  }
}

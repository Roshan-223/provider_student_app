import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_students_detail/controller_provider.dart';
import 'package:provider_students_detail/screens/add_students.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var studentList =
          await Provider.of<ControllerProvider>(context, listen: false)
              .getstudent();

      // ignore: use_build_context_synchronously
      Provider.of<ControllerProvider>(context, listen: false).studentlist =
          studentList;
    });
  }

  String query = '';

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ControllerProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'Students Profile',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(bottom: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),    
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Consumer<ControllerProvider>(
          builder: (context, studentList, child) {
            final list = controller.studentlist
                .where((element) =>
                    element.name!.toLowerCase().contains(query.toLowerCase()))
                .toList();
            if (list.isEmpty) {
              return const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(list[index].imageurl!)),
                    radius: 30,
                  ),
                  title: Text(
                    list[index].name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(list[index].place!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => AddStudent(model: list[index]),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          int studentId = list[index].id!;
                          await controller.deleteStudent(studentId);

                          var updatedStudentList =
                              await controller.getstudent();
                          controller.studentlist = updatedStudentList;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final updatedStudent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AddStudent(model: list[index]),
                            ),
                          );
                          if (updatedStudent != null) {
                            controller.studentUpdateFn(updatedStudent);
                          }
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: list.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudent(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_students_detail/controller_provider.dart';
import 'package:provider_students_detail/database/db_function.dart';
import 'package:provider_students_detail/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dataBase.initializeDataBase();
  runApp(
    ChangeNotifierProvider(
    create: (context) => ControllerProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sampleApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Myhomepage(),
    );
  }
}

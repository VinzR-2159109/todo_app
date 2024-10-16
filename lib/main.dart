import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'toDoLists_Overview.dart';
import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ToDoListAdapter());

  await Hive.openBox<ToDoList>('todoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToDoListsOverview(),
    );
  }
}

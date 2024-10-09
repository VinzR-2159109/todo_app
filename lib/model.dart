import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

@HiveType(typeId: 1)
class ToDoList extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<Task> tasks;

  ToDoList({required this.title, required this.tasks});
}

class ToDoListsModel {
  final Box<ToDoList> box = Hive.box<ToDoList>('todoBox');

  List<ToDoList> get todoLists => box.values.toList();

  void addToDoList(String title) {
    final newList = ToDoList(title: title, tasks: []);
    box.add(newList);
  }

  void deleteSelected(List<bool> selectedItems) {
    final itemsToDelete = todoLists.asMap().entries
        .where((entry) => selectedItems[entry.key])
        .map((entry) => entry.value)
        .toList();
    for (var item in itemsToDelete) {
      item.delete();
    }
  }
}

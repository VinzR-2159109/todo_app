class ToDoListsModel {
  List<ToDoList> todoLists = [];

  void addToDoList(String title) {
    todoLists.add(ToDoList(title: title, tasks: []));
  }

  void deleteSelected(List<bool> selectedItems) {
    todoLists = todoLists
        .asMap()
        .entries
        .where((entry) => !selectedItems[entry.key])
        .map((entry) => entry.value)
        .toList();
  }
}

class ToDoList {
  String title;
  List<Task> tasks;

  ToDoList({required this.title, required this.tasks});
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

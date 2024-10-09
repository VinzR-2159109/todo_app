import 'package:flutter/material.dart';
import 'package:todo_app/model.dart';

class ToDoListScreen extends StatefulWidget {
  final ToDoList todoList;

  const ToDoListScreen({super.key, required this.todoList});

  @override
  ToDoListScreenState createState() => ToDoListScreenState();
}

class ToDoListScreenState extends State<ToDoListScreen> {
  void _addTask(String title) {
    setState(() {
      widget.todoList.tasks.add(Task(title: title));
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      widget.todoList.tasks[index].isCompleted = !widget.todoList.tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      widget.todoList.tasks.removeAt(index);
    });
  }

  void _deleteCompletedTasks() {
    setState(() {
      widget.todoList.tasks.removeWhere((task) => task.isCompleted);
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = taskController.text.trim();
                if (title.isNotEmpty) {
                  _addTask(title);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoList.title),
      ),
      body: widget.todoList.tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ReorderableListView.builder(
              itemCount: widget.todoList.tasks.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final task = widget.todoList.tasks.removeAt(oldIndex);
                  widget.todoList.tasks.insert(newIndex, task);
                });
              },
              itemBuilder: (context, index) {
                final task = widget.todoList.tasks[index];
                return Dismissible(
                  key: ValueKey(task),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteTask(index),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleTaskCompletion(index),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.drag_handle),
                  ),
                );
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.todoList.tasks.any((task) => task.isCompleted))
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FloatingActionButton(
                onPressed: _deleteCompletedTasks,
                backgroundColor: Colors.red,
                tooltip: 'Delete completed tasks',
                child: const Icon(Icons.delete),
              ),
            ),
          FloatingActionButton(
            onPressed: () => _showAddTaskDialog(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

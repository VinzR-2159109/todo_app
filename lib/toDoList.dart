import 'package:flutter/material.dart';
import 'model.dart';

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
      widget.todoList.save();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      widget.todoList.tasks[index].isCompleted = !widget.todoList.tasks[index].isCompleted;
      widget.todoList.save();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      widget.todoList.tasks.removeAt(index);
      widget.todoList.save();
    });
  }

  void _deleteCompletedTasks() {
    setState(() {
      widget.todoList.tasks.removeWhere((task) => task.isCompleted);
      widget.todoList.save();
    });
  }

  void _editTask(int index) {
    final TextEditingController editController = TextEditingController(text: widget.todoList.tasks[index].title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Enter new task title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.todoList.tasks[index].title = editController.text.trim();
                  widget.todoList.save();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
                  widget.todoList.save();
                });
              },
              itemBuilder: (context, index) {
                final task = widget.todoList.tasks[index];
                return Dismissible(
                  key: ValueKey(task),
                  background: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _editTask(index);
                      return false; // Prevent dismissal for edit action
                    } else if (direction == DismissDirection.endToStart) {
                      _deleteTask(index);
                      return true; // Allow dismissal for delete action
                    }
                    return false;
                  },
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
                heroTag: 'deleteTasksButton', // Unique hero tag
                tooltip: 'Delete completed tasks',
                child: const Icon(Icons.delete),
              ),
            ),
          FloatingActionButton(
            onPressed: () => _showAddTaskDialog(context),
            heroTag: 'addTaskButton', // Unique hero tag
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

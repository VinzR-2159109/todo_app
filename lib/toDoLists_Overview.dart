import 'package:flutter/material.dart';
import 'toDoList.dart';
import 'model.dart';

class ToDoListsOverview extends StatefulWidget {
  final ToDoListsModel toDoListsModel = ToDoListsModel();

  ToDoListsOverview({super.key});

  @override
  ToDoListsOverviewState createState() => ToDoListsOverviewState();
}

class ToDoListsOverviewState extends State<ToDoListsOverview> {
  List<bool> selectedItems = [];
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    selectedItems = List.generate(widget.toDoListsModel.todoLists.length, (index) => false);
  }

  void _addToDoList(String title) {
    setState(() {
      widget.toDoListsModel.addToDoList(title);
      selectedItems = List.generate(widget.toDoListsModel.todoLists.length, (index) => false);
    });
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Selected'),
          content: const Text('Are you sure you want to delete the selected lists?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.toDoListsModel.deleteSelected(selectedItems);
                  selectedItems = List.generate(widget.toDoListsModel.todoLists.length, (index) => false);
                  isSelecting = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelecting = !isSelecting;
    });
  }

  void _toggleItemSelection(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index];
      isSelecting = selectedItems.contains(true);
    });
  }

  void _showAddToDoListDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add ToDo List'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter list title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = titleController.text.trim();
                if (title.isNotEmpty) {
                  _addToDoList(title);
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
        title: Text(isSelecting ? '${selectedItems.where((item) => item).length} selected' : 'ToDo Lists'),
        leading: isSelecting
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSelectionMode,
              )
            : null,
      ),
      body: widget.toDoListsModel.todoLists.isEmpty
          ? const Center(
              child: Text(
                'Click the + button to add a new ToDo List',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.toDoListsModel.todoLists.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Text(widget.toDoListsModel.todoLists[index].title),
                    onTap: () {
                      if (isSelecting) {
                        _toggleItemSelection(index);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ToDoListScreen(todoList: widget.toDoListsModel.todoLists[index]),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      _toggleSelectionMode();
                      _toggleItemSelection(index);
                    },
                    trailing: isSelecting
                        ? Checkbox(
                            value: selectedItems[index],
                            onChanged: (bool? value) => _toggleItemSelection(index),
                          )
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isSelecting)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FloatingActionButton(
                onPressed: _deleteSelected,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete),
              ),
            ),
          FloatingActionButton(
            onPressed: () => _showAddToDoListDialog(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

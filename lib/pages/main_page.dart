import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/entity/todo.dart';
import 'package:todo_list/widgets/add_button.dart';
import 'package:todo_list/widgets/todo_body.dart';
import 'package:todo_list/widgets/todo_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    required this.prefs,
    super.key,
  });

  // Add prefs field
  final SharedPreferences prefs;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //Create todos list
  final List<ToDo> _todos = [];

  @override
  void initState() {
    //Show saved todos
    _init();
    super.initState();
  }

  //Create method for showing saved todos
  void _init() {
    final keys = widget.prefs.getKeys();
    for (final key in keys) {
      final json = widget.prefs.getString(key);
      final todo = ToDo.fromJSON(json!, key);
      _todos..add(todo)
      ..sort((a, b) => a.index.compareTo(b.index));
    }
    print(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        title: const Text('ToDo'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            // Check if there are todos in list and show delete button if true
            child: _todos.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      setState(
                        () {
                          //Delete all todos in list (and memory)
                          for (final todo in _todos) {
                            widget.prefs.remove(todo.id);
                          }

                          _todos.clear();
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
          ),
        ],
      ),
      body: TodoListBody(
        todos: _todos,
        prefs: widget.prefs,
        displayDialog: _displayDialog,
      ),
      floatingActionButton: AddButton(
        isVisible: _todos.isNotEmpty,
        onTap: _displayDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Todos creating method
  void _addTodoItem(String name) {
    // Create ToDo instance from display dialog (name = text)
    final todo = ToDo(name: name, completed: false, index: _todos.length);

    //Save this todos in prefs
    widget.prefs.setString(todo.id, todo.toJSON());

    //Add this todos in our todos list
    setState(() {
      _todos.add(todo);
    });
  }

  //Show dialog for adding todos
  Future<void> _displayDialog() async {
    final text = await showDialog<String?>(
      context: context,
      //When we tap out of dialog it doesn't close
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const TodoDialog(
          title: 'Add a ToDo',
          buttonName: 'Add',
        );
      },
    );
    if (text != null) {
      //If we have text in dialog textfiel or empty (not null) textfield
      //we add this text to todos creating method
      _addTodoItem(text);
    }
  }
}

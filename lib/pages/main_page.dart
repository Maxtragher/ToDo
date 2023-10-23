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

  final SharedPreferences prefs;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<ToDo> _todos = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    final keys = widget.prefs.getKeys();
    for (final key in keys) {
      final json = widget.prefs.getString(key);
      final todo = ToDo.fromJSON(json!, key);
      _todos.add(todo);
    }
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
            child: _todos.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      setState(
                        () {
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

  void _addTodoItem(String name) {
    final todo = ToDo(name: name, completed: false);
    widget.prefs.setString(todo.id, todo.toJSON());
    setState(() {
      _todos.add(todo);
    });
  }

  Future<void> _displayDialog() async {
    final text = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const TodoDialog(
          title: 'Add a ToDo',
          buttonName: 'Add',
        );
      },
    );
    if (text != null) {
      _addTodoItem(text);
    }
  }
}

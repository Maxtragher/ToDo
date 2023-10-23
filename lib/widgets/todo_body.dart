import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/entity/todo.dart';
import 'package:todo_list/pages/todo_item.dart';

class TodoListBody extends StatefulWidget {
  const TodoListBody({
    required this.todos,
    required this.prefs,
    required this.displayDialog,
    super.key,
  });

  final List<ToDo> todos;
  final SharedPreferences prefs;
  final void Function() displayDialog;

  @override
  State<TodoListBody> createState() => _TodoListBodyState();
}

class _TodoListBodyState extends State<TodoListBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.todos.isEmpty) {
      return Center(
        child: TextButton(
          onPressed: widget.displayDialog,
          child: Text(
            'Create a ToDo',
            style: TextStyle(
              color: Theme.of(context).appBarTheme.backgroundColor,
              fontSize: 20,
            ),
          ),
        ),
      );
    }
    return ReorderableListView.builder(
      onReorder: _reorderTodo,
      itemCount: widget.todos.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => ToDoItem(
        todo: widget.todos[index],
        onTodoChanged: _handleTodoChange,
        deleteTodo: _deleteTodo,
      ),
    );
  }

  void _reorderTodo(int oldIndex, int newIndex) {
    setState(() {
      final index = oldIndex < newIndex ? newIndex - 1 : newIndex;

      final todo = widget.todos.removeAt(oldIndex);

      widget.todos.insert(index, todo);
    });
  }

  void _handleTodoChange(ToDo todo) {
    widget.prefs.setString(todo.id, todo.toJSON());
    setState(() {
      final index = widget.todos.indexWhere((element) => element.id == todo.id);
      widget.todos[index] = todo;
    });
  }

  void _deleteTodo(ToDo todo) {
    widget.prefs.remove(todo.id);
    setState(() {
      widget.todos.removeWhere((element) => element.id == todo.id);
    });
  }
}

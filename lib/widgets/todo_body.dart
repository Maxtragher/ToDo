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

  //For sending todos list to main_page we create todos list here
  final List<ToDo> todos;
  final SharedPreferences prefs;
  final void Function() displayDialog;

  @override
  State<TodoListBody> createState() => _TodoListBodyState();
}

class _TodoListBodyState extends State<TodoListBody> {
  @override
  Widget build(BuildContext context) {
    //If todos list is empty we show textButton for adding todos
    if (widget.todos.isEmpty) {
      return Center(
        child: TextButton(
          //Invoke display dialog
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
    //With Theme we fixed incorrect behavior on reorderabing
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      //Create list with todos items wich we can reorder
      child: ReorderableListView.builder(
        onReorder: _reorderTodo,
        itemCount: widget.todos.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        //Add todos items in a showing list
        itemBuilder: (context, index) => ToDoItem(
          todo: widget.todos[index],
          onTodoChanged: _handleTodoChange,
          deleteTodo: _deleteTodo,
        ),
      ),
    );
  }

  //Create onReorder method
  void _reorderTodo(int oldIndex, int newIndex) {
    setState(() {
      final index = oldIndex < newIndex ? newIndex - 1 : newIndex;

      final todo = widget.todos.removeAt(oldIndex);

      widget.todos.insert(index, todo);
    });
  }

  //Invoke if we want to change todos text or completing
  void _handleTodoChange(ToDo todo) {
    //Saving changed todos in prefs
    widget.prefs.setString(todo.id, todo.toJSON());
    setState(() {
      final index = widget.todos.indexWhere((element) => element.id == todo.id);
      widget.todos[index] = todo;
    });
  }

  void _deleteTodo(ToDo todo) {
    final todoIndex = widget.todos.indexOf(todo);
    //Remove todos item in prefs memory
    widget.prefs.remove(todo.id);
    setState(() {
      widget.todos.removeWhere((element) => element.id == todo.id);

      //Add "Undo" for removed todos
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense «${todo.name}» removed'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              widget.prefs.setString(todo.id, todo.toJSON());
              setState(() {
                widget.todos.insert(todoIndex, todo);
              });
            },
          ),
        ),
      );
    });
  }
}

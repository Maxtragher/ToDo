import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/entity/todo.dart';
import 'package:todo_list/widgets/todo_dialog.dart';

class ToDoItem extends StatelessWidget {
  ToDoItem({
    required this.todo,
    required this.onTodoChanged,
    required this.deleteTodo,
  }) : super(key: ObjectKey(todo));
  final ToDo todo;
  final void Function(ToDo todo) onTodoChanged;
  final void Function(ToDo todo) deleteTodo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteTodo(todo);
              },
              icon: Icons.delete,
              backgroundColor: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ),
        //Add container with key for correct reorder
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          key: ValueKey(todo.id),
          child: ListTile(
            onTap: () async {
              //For change and save text create newText and
              //invoke onTodoChanged
              final newText = await _displayDialog(context, todo.name);
              onTodoChanged(todo.copyWith(name: newText));
            },
            leading: Checkbox(
              value: todo.completed,
              onChanged: (value) =>
                  onTodoChanged(todo.copyWith(completed: !todo.completed)),
            ),
            title: Text(
              todo.name,
              style: _getTextStyle(todo.completed),
            ),
            focusColor: Theme.of(context).cardColor,
            hoverColor: Theme.of(context).cardColor,
          ),
        ),
      ),
    );
  }

  TextStyle? _getTextStyle(bool completed) {
    if (!completed) return null;
    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }

  Future<String?> _displayDialog(BuildContext context, String todoText) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TodoDialog(
          todoText: todoText,
          title: 'Edit a ToDo',
          buttonName: 'Edit',
        );
      },
    );
  }
}

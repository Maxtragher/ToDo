import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/presentation/cubit/todo_cubit.dart';
import 'package:todo_list/presentation/pages/todo_item.dart';

class TodoListBody extends StatefulWidget {
  const TodoListBody({
    required this.displayDialog,
    super.key,
  });

  final void Function() displayDialog;

  @override
  State<TodoListBody> createState() => _TodoListBodyState();
}

class _TodoListBodyState extends State<TodoListBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state.todos.isEmpty) {
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
            onReorder: context.read<TodoCubit>().reorderTodo,
            itemCount: state.todos.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            //Add todos items in a showing list
            itemBuilder: (context, index) => ToDoItem(
              todo: state.todos[index],
              onTodoChanged: context.read<TodoCubit>().updateTodo,
              deleteTodo: context.read<TodoCubit>().deleteTodo,
              undoTodo: context.read<TodoCubit>().undoTodo,
            ),
          ),
        );
      },
    );
  }
}

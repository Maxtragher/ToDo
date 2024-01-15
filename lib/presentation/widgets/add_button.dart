import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/presentation/cubit/todo_cubit.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    required this.onTap,
    super.key,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Visibility(
          visible: state.todos.isNotEmpty,
          child: FloatingActionButton(
            onPressed: onTap,
            tooltip: 'Add a todo',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

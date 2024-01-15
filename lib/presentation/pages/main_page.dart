import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/data/todo_repository.dart';
import 'package:todo_list/presentation/cubit/todo_cubit.dart';
import 'package:todo_list/presentation/widgets/add_button.dart';
import 'package:todo_list/presentation/widgets/todo_body.dart';
import 'package:todo_list/presentation/widgets/todo_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final TodoCubit todoCubit;

  @override
  void initState() {
    todoCubit = TodoCubit(context.read<TodoRepository>())..init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: todoCubit,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shadowColor: Colors.transparent,
          title: const Text('ToDo'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // Check if there are todos in list and show delete button if true
              child: BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) {
                  return state.todos.isEmpty
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            context.read<TodoCubit>().deleteAllTodos();
                          },
                          icon: const Icon(Icons.delete),
                        );
                },
              ),
            ),
          ],
        ),
        body: TodoListBody(
          displayDialog: _displayDialog,
        ),
        floatingActionButton: AddButton(
          onTap: _displayDialog,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
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
      todoCubit.addTodo(text);
    }
  }
}

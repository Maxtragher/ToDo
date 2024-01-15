import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/data/todo_repository.dart';
import 'package:todo_list/entity/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._todoRepository) : super(const TodoState(todos: []));

  final TodoRepository _todoRepository;
  List<ToDo> todos = [];

  void init() {
    todos = _todoRepository.getTodos();
    emit(TodoState(todos: todos));
  }

  void addTodo(String name) {
    final todo = ToDo(name: name, completed: false, index: todos.length);

    todos.add(todo);

    _todoRepository.saveTodos(todos);

    emit(TodoState(todos: todos));
  }

  void deleteTodo(ToDo todo) {
    _todoRepository.deleteTodo(todo);

    todos.removeWhere((element) => element.id == todo.id);

    emit(TodoState(todos: todos));
  }

  void deleteAllTodos() {
    for (final todo in todos) {
      _todoRepository.deleteTodo(todo);
    }
    todos.clear();
    emit(TodoState(todos: todos));
  }

  void updateTodo(ToDo updatedTodo) {
    final index = todos.indexWhere((element) => element.id == updatedTodo.id);
    todos[index] = updatedTodo;
    emit(TodoState(todos: todos));
  }

  void reorderTodo(int oldIndex, int newIndex) {
    final index = oldIndex < newIndex ? newIndex - 1 : newIndex;

    final todo = todos.removeAt(oldIndex);

    todos.insert(index, todo);

    for (var i = 0; i < todos.length; i++) {
      _todoRepository.deleteTodo(todos[i]);
      todos[i] = todos[i].copyWith(index: i);
    }
    _todoRepository.saveTodos(todos);
    emit(TodoState(todos: todos));
  }

  void undoTodo(ToDo todo, BuildContext context) {
    // final todoIndex = todos.indexOf(todo);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Todo «${todo.index + 1}» removed',
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            todos.add(todo);

            _todoRepository.saveTodos(todos);

            emit(TodoState(todos: todos));
          },
        ),
      ),
    );
  }
}

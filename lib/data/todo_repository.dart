import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/entity/todo.dart';

class TodoRepository {
  TodoRepository(this._prefs);

  final SharedPreferences _prefs;

  void saveTodos(List<ToDo> todos) {
    for (final todo in todos) {
      _prefs.setString(todo.id, todo.toJSON());
    }
  }

  void deleteTodo(ToDo todo) {
    _prefs.remove(todo.id);
  }

  List<ToDo> getTodos() {
    final todos = <ToDo>[];
    final keys = _prefs.getKeys();
    for (final key in keys) {
      final json = _prefs.getString(key);
      final todo = ToDo.fromJSON(json!, key);
      todos
        ..add(todo)
        ..sort((a, b) => a.index.compareTo(b.index));
    }
    return todos;
  }
}

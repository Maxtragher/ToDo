import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

//Create todos class
class ToDo extends Equatable {
  ToDo({
    required this.name,
    required this.completed,
    required this.index,
    String? id,
  }) : id = id ?? _uuid.v7();

  //Factory named constructor for decoding JSON todos
  //and returning todos from map
  factory ToDo.fromJSON(String json, String id) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return ToDo(
      name: map['name'] as String,
      completed: map['isCompleted'] as bool,
      id: id,
      index: map['index'] as int,
    );
  }
  static const _uuid = Uuid();

//Todos have their name, completed value, id and index(for saving reordering instance)
  final String id;
  final String name;
  final bool completed;
  int index;

  //Override Equatable method
  @override
  List<Object?> get props => [name, completed, id, index];

  @override
  bool get stringify => true;

  //Method for returning new todos when we change it
  ToDo copyWith({String? name, bool? completed, DateTime? date}) => ToDo(
        name: name ?? this.name,
        completed: completed ?? this.completed,
        id: id,
        index: index,
      );

  //Method for code todos in JSON for saving in prefs
  String toJSON() {
    final map = {
      'name': name,
      'isCompleted': completed,
      'index': index,
    };
    return jsonEncode(map);
  }
}

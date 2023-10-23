import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class ToDo extends Equatable {
  ToDo({required this.name, required this.completed, String? id})
      : id = id ?? _uuid.v7();

  factory ToDo.fromJSON(String json, String id) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return ToDo(
      name: map['name'] as String,
      completed: map['isCompleted'] as bool,
      id: id,
    );
  }
  static const _uuid = Uuid();

  final String id;
  final String name;
  final bool completed;

  @override
  List<Object?> get props => [name, completed, id];

  @override
  bool get stringify => true;

  ToDo copyWith({String? name, bool? completed}) => ToDo(
        name: name ?? this.name,
        completed: completed ?? this.completed,
        id: id,
      );

  String toJSON() {
    final map = {'name': name, 'isCompleted': completed};
    return jsonEncode(map);
  }
}

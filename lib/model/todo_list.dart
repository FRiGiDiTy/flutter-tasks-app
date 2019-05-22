import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list_entity.dart';

class TodoList {
  final String id;
  String title;
  List<Todo> todos;
  int position;

  TodoList({this.id, this.title = '', List<Todo> todos, this.position}) : this.todos = todos ?? [];

  TodoList copyWith({String id, String title, List<Todo> todos}) {
    return TodoList(
      id: id ?? this.id,
      title: title ?? this.title,
      todos: todos ?? this.todos,
    );
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ todos.hashCode ^ position.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          todos == other.todos &&
          position == other.position;

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, todos: $todos, position: $position}';
  }

  TodoListEntity toEntity() {
    return TodoListEntity(
        id: id,
        title: title,
        todos: todos.map((todo) => todo.toEntity()).toList(),
        position: position);
  }

  static TodoList fromEntity(TodoListEntity entity) {
    return TodoList(
        id: entity.id,
        title: entity.title,
        todos: entity.todos.map((entity) => Todo.fromEntity(entity)).toList(),
        position: entity.position);
  }
}


import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<dynamic>? todo;

  const Task(
      {required this.title,
      required this.icon,
      required this.color,
      this.todo});

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<dynamic>? todos,
  }) =>
      Task(
          title: title ?? this.title,
          icon: icon ?? this.icon,
          color: color ?? this.color,
          todo: todos ?? this.todo);

  factory Task.fromJson(Map<String, dynamic> json) => Task(
      title: json["title"],
      icon:  json["icon"],
      color:  json["color"],
      todo:  json["todo"]
  );

  Map<String, dynamic> toJson()=>{
    'title': title,
    'icon': icon,
    'color': color,
    'todo': todo
  };

  @override
  // TODO: implement props
  List<Object?> get props => [title,icon,color];
}

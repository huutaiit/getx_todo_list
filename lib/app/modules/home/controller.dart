import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/data/models/task.dart';
import 'package:getx_todo_list/app/data/services/storege/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;

  HomeController({required this.taskRepository});

  final formKey = GlobalKey<FormState>();
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final editController = TextEditingController();
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  void changeTask(Task? select) {
    task.value = select;
  }

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  bool addTodo(String title) {
    var todo = {"title":title,'done':false};
    if(doingTodos.any((element)=>mapEquals<String, dynamic>(todo, element))){
      return false;
    }
    var doneTodo = {"title":title,'done':false};
    if(doneTodos.any((element)=>mapEquals<String, dynamic>(doneTodo, element))){
      return false;
    }
    doneTodos.add(todo);
    return true;
  }



  void updateTodos(){
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;

    tasks.refresh();
  }

  updateTask(Task task, String title) {
    var todos = task.todo ?? [];
    if(containerTodo(todos,title)){
      return false;
    }
    var todo = {'title':title,'done':false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containerTodo(List todo, String title) {
    return todo.any((element) => element["title"] == title);

  }

  void doneTodo(String title) {
    var doingTodo = {'title':title,'done':false};
    int index = doingTodos.indexWhere((element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {"title": title, "done":true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();



  }


}

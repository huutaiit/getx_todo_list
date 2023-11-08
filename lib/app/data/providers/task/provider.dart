import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_todo_list/app/data/services/storege/services.dart';

import '../../../core/utils/keys.dart';
import '../../models/task.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();

  List<Task> readTasks() {
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString()).forEach((e) => {tasks.add(Task.fromJson(e))});
    return tasks;
  }

  void writeTasks(List<Task> task) {
    _storage.write(taskKey, jsonEncode(task));
  }
}

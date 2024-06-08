import 'dart:convert';

class TaskModal {
  final String title;
  final String description;

  TaskModal({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  static TaskModal fromJson(Map<String, dynamic> json) {
    return TaskModal(
      title: json['title'],
      description: json['description'],
    );
  }

  static List<TaskModal> decodeJsonList(String jsonList) {
    final Iterable decoded = json.decode(jsonList);
    return List<TaskModal>.from(
        decoded.map((item) => TaskModal.fromJson(item)));
  }

  static String encodeJsonList(List<TaskModal> tasks) {
    final List<Map<String, dynamic>> taskList =
        tasks.map((task) => task.toJson()).toList();
    return json.encode(taskList);
  }
}

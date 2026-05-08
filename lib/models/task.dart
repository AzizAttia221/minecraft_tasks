class Task {
  final String id;
  final String name;
  final String category;
  final String description;
  final String priority;
  final DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.priority = 'Normal',
    this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      priority: json['priority'] ?? 'Normal',
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
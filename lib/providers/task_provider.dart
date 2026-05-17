import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      name: 'coal generator',
      category: 'automation',
      description: 'Build an automated coal generator',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      id: '2',
      name: 'enchantments',
      category: 'magic',
      description: 'Set up enchantment table',
      priority: 'Normal',
      dueDate: DateTime.now().add(const Duration(days: 6)),
    ),
    Task(
      id: '3',
      name: 'iron farm',
      category: 'farming',
      description: 'Create an iron golem farm',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 10)),
    ),
    Task(
      id: '4',
      name: 'breed two piglins',
      category: 'animals',
      description: 'Breed piglins in the nether',
      priority: 'Low',
    ),
    Task(
      id: '5',
      name: 'mob farm',
      category: 'farming',
      description: 'Build a mob spawner farm',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      id: '6',
      name: 'kill dragon',
      category: 'combat',
      description: 'Defeat the ender dragon',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 14)),
    ),
  ];

  List<Task> get tasks => _tasks;
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<String> get categories => [
        'All',
        ..._tasks.map((task) => task.category).toSet().toList(),
      ];

  int get totalTasks => _tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
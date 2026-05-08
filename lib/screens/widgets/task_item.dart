import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  Color get _priorityColor {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFF9A825);
      case 'low':
        return const Color(0xFF4FC3F7);
      default:
        return const Color(0xFF8BC34A);
    }
  }

  String get _dueLabel {
    if (task.dueDate == null) return 'No due date';
    return 'Due ${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFB33A3A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(3, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          title: Text(
            task.name,
            style: TextStyle(
              color: task.isCompleted ? Colors.white54 : Colors.white,
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                task.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Text(
                      task.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'monospace',
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _priorityColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        color: _priorityColor,
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _dueLabel,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: task.isCompleted ? const Color(0xFF3DBB4F) : const Color.fromRGBO(255, 255, 255, 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 26)
                  : const Icon(Icons.circle_outlined, color: Colors.white70, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

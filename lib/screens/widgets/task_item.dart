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

  Color get _priorityBackgroundColor {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return const Color.fromRGBO(255, 107, 107, 0.18);
      case 'medium':
        return const Color.fromRGBO(249, 168, 37, 0.18);
      case 'low':
        return const Color.fromRGBO(79, 195, 247, 0.18);
      default:
        return const Color.fromRGBO(139, 195, 74, 0.18);
    }
  }

  bool get _isOverdue {
    if (task.dueDate == null || task.isCompleted) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }

  String get _dueLabel {
    if (task.dueDate == null) return 'No due date';
    return '${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}';
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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(20, 27, 31, 1),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.12), width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            task.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: task.isCompleted ? Colors.white54 : Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (_isOverdue)
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB33A3A),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text(
                                'OVERDUE',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildBadge(task.category.toUpperCase(), const Color.fromRGBO(255, 255, 255, 0.08)),
                        _buildBadge(task.priority.toUpperCase(), _priorityBackgroundColor, textColor: _priorityColor),
                        _buildBadge(_dueLabel, const Color.fromRGBO(255, 255, 255, 0.06), textColor: Colors.white54),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: task.isCompleted ? const Color(0xFF3DBB4F) : const Color.fromRGBO(255, 255, 255, 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.14), width: 1.2),
                  ),
                  child: Icon(
                    task.isCompleted ? Icons.check : Icons.circle_outlined,
                    color: task.isCompleted ? Colors.white : Colors.white70,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color backgroundColor, {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontFamily: 'monospace',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

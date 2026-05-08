import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'widgets/minecraft_background.dart';
import 'widgets/minecraft_button.dart';
import 'widgets/task_item.dart';
import 'add_task_page.dart';
import 'pending_tasks_page.dart';

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: MinecraftBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome, ${authProvider.currentUserDisplayName}!',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white24, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          offset: Offset(4, 4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          child: Row(
                            children: const [
                              Text(
                                'Completed Tasks',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Consumer<TaskProvider>(
                            builder: (context, taskProvider, child) {
                              final tasks = taskProvider.completedTasks;

                              if (tasks.isEmpty) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(255, 255, 255, 0.10),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white24, width: 2),
                                    ),
                                    child: const Text(
                                      'No completed tasks yet!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return TaskItem(
                                    task: task,
                                    onToggle: () => taskProvider.toggleTask(task.id),
                                    onDelete: () {
                                      taskProvider.deleteTask(task.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Deleted "${task.name}"'),
                                          backgroundColor: const Color(0xFFB33A3A),
                                        ),
                                      );
                                    },
                                    onTap: () {},
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                          child: MinecraftButton(
                            text: '+ Add Task',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddTaskPage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PendingTasksPage()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF3DBB4F),
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.grid_on, color: Colors.black, size: 32),
            ),
            const SizedBox(width: 14),
            const Text(
              'MINECRAFT TASKS',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
          tooltip: 'Profile',
        ),
      ],
    );
  }
}
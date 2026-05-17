import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'widgets/minecraft_background.dart';
import 'widgets/minecraft_button.dart';
import 'widgets/minecraft_text_field.dart';
import 'widgets/task_item.dart';
import 'add_task_page.dart';
import 'completed_tasks_page.dart';

class PendingTasksPage extends StatefulWidget {
  const PendingTasksPage({super.key});

  @override
  State<PendingTasksPage> createState() => _PendingTasksPageState();
}

class _PendingTasksPageState extends State<PendingTasksPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _showTopPanel = true;
  double _lastScrollOffset = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final currentOffset = _scrollController.position.pixels;
      if (currentOffset > _lastScrollOffset + 12 && _showTopPanel) {
        setState(() {
          _showTopPanel = false;
        });
      } else if (currentOffset < _lastScrollOffset - 12 && !_showTopPanel) {
        setState(() {
          _showTopPanel = true;
        });
      }
      _lastScrollOffset = currentOffset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Task> _filterTasks(TaskProvider provider) {
    final query = _searchController.text.toLowerCase().trim();
    return provider.pendingTasks.where((task) {
      final searchMatch = query.isEmpty ||
          task.name.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          task.category.toLowerCase().contains(query);
      final categoryMatch = _selectedCategory == 'All' || task.category == _selectedCategory;
      return searchMatch && categoryMatch;
    }).toList();
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(18, 18, 18, 0.98),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 48,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                task.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                task.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'monospace',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildDetailChip('Category', task.category),
                  _buildDetailChip('Priority', task.priority),
                  _buildDetailChip(
                    'Due',
                    task.dueDate == null
                        ? 'None'
                        : '${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              MinecraftButton(
                text: 'close',
                onPressed: () => Navigator.of(context).pop(),
                color: const Color(0xFF5A9E4A),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          color: Colors.white70,
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      ),
    );
  }

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
              const SizedBox(height: 12),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _showTopPanel ? 1 : 0,
                    child: AnimatedOpacity(
                      opacity: _showTopPanel ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, ${authProvider.currentUserDisplayName}!',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'monospace',
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Consumer<TaskProvider>(
                                  builder: (context, taskProvider, child) {
                                    final progress = taskProvider.totalTasks == 0
                                        ? 0.0
                                        : taskProvider.completedCount / taskProvider.totalTasks;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildMiniStat(
                                                'Pending',
                                                taskProvider.pendingCount.toString(),
                                                Icons.schedule,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: _buildMiniStat(
                                                'Completed',
                                                taskProvider.completedCount.toString(),
                                                Icons.check_circle,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: _buildMiniStat(
                                                'Total',
                                                taskProvider.totalTasks.toString(),
                                                Icons.stacked_line_chart,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 6,
                                            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.08),
                                            valueColor: const AlwaysStoppedAnimation(Color(0xFF3DBB4F)),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 18),
                                MinecraftTextField(
                                  controller: _searchController,
                                  hintText: 'Search tasks...',
                                  icon: Icons.search,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 14),
                                Consumer<TaskProvider>(
                                  builder: (context, taskProvider, child) {
                                    return Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: taskProvider.categories.map((category) {
                                        final isSelected = _selectedCategory == category;
                                        return ChoiceChip(
                                          label: Text(
                                            category,
                                            style: TextStyle(
                                              color: isSelected ? Colors.black : Colors.white,
                                              fontFamily: 'monospace',
                                              fontSize: 12,
                                            ),
                                          ),
                                          selected: isSelected,
                                          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.10),
                                          selectedColor: const Color(0xFF3DBB4F),
                                          onSelected: (_) {
                                            setState(() {
                                              _selectedCategory = category;
                                            });
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Pending Tasks',
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
                              final tasks = _filterTasks(taskProvider);

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
                                      'No matching tasks found.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                controller: _scrollController,
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
                                    onTap: () => _showTaskDetails(context, task),
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

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.12), width: 1.3),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF3DBB4F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
          tooltip: 'Profile',
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Flexible(
                child: Text(
                  'MINECRAFT TASKS',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CompletedTasksPage()),
            );
          },
          icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
          tooltip: 'Completed Tasks',
        ),
      ],
    );
  }
}

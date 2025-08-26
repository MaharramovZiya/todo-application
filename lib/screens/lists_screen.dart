import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_card.dart';
import 'todos_screen.dart';
import 'add_task_screen.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodos();
      context.read<TodoProvider>().initializeWithSampleData();
    });
  }

  void _onCategoryTap(TodoCategory category) {
    context.read<TodoProvider>().setSelectedCategory(category);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TodosScreen(category: category)),
    );
  }

  void _onAddTask() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onTaskCreated: (todo) {
            context.read<TodoProvider>().addTodo(todo);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement menu
                    },
                    icon: const Icon(Icons.menu),
                    iconSize: AppSizes.iconSizeM,
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Lists', style: AppTextStyles.headline1),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for balance
                ],
              ),
            ),

            // Categories Grid
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSizes.paddingM,
                          mainAxisSpacing: AppSizes.paddingM,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: TodoCategory.values.length,
                    itemBuilder: (context, index) {
                      final category = TodoCategory.values[index];
                      final taskCount = todoProvider.getTaskCountByCategory(
                        category,
                      );

                      return CategoryCard(
                        category: category,
                        taskCount: taskCount,
                        onTap: () => _onCategoryTap(category),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTask,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        child: const Icon(Icons.add, size: AppSizes.iconSizeL),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/todo_section.dart';
import 'add_task_screen.dart';

class TodosScreen extends StatelessWidget {
  final TodoCategory category;

  const TodosScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with blue background
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.radiusL),
                  bottomRight: Radius.circular(AppSizes.radiusL),
                ),
              ),
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.surface,
                    ),
                    iconSize: AppSizes.iconSizeM,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSizes.paddingS),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusS,
                            ),
                          ),
                          child: Icon(
                            AppHelpers.getCategoryIcon(category),
                            color: AppColors.surface,
                            size: AppSizes.iconSizeM,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppHelpers.getCategoryName(category),
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.surface,
                              ),
                            ),
                            Consumer<TodoProvider>(
                              builder: (context, todoProvider, child) {
                                final taskCount = todoProvider
                                    .getTaskCountByCategory(category);
                                return Text(
                                  AppHelpers.formatTaskCount(taskCount),
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.surface.withOpacity(0.8),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement menu
                    },
                    icon: const Icon(Icons.more_vert, color: AppColors.surface),
                    iconSize: AppSizes.iconSizeM,
                  ),
                ],
              ),
            ),

            // Todo sections
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  final todos = todoProvider.getTodosByCategory(category);
                  final lateTodos = todos.where((todo) => todo.isLate).toList();
                  final todayTodos = todos
                      .where((todo) => todo.isToday)
                      .toList();
                  final completedTodos = todos
                      .where((todo) => todo.status == TodoStatus.completed)
                      .toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(top: AppSizes.paddingM),
                    child: Column(
                      children: [
                        // Late section
                        TodoSection(
                          title: 'Late',
                          todos: lateTodos,
                          onTodoTap: (todo) {
                            // TODO: Implement todo edit
                          },
                          onCheckboxChanged: (todo) {
                            todoProvider.toggleTodoCompletion(todo.id);
                          },
                        ),

                        // Today section
                        TodoSection(
                          title: 'Today',
                          todos: todayTodos,
                          onTodoTap: (todo) {
                            // TODO: Implement todo edit
                          },
                          onCheckboxChanged: (todo) {
                            todoProvider.toggleTodoCompletion(todo.id);
                          },
                        ),

                        // Done section
                        TodoSection(
                          title: 'Done',
                          todos: completedTodos,
                          onTodoTap: (todo) {
                            // TODO: Implement todo edit
                          },
                          onCheckboxChanged: (todo) {
                            todoProvider.toggleTodoCompletion(todo.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                initialCategory: category,
                onTaskCreated: (todo) {
                  context.read<TodoProvider>().addTodo(todo);
                },
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        child: const Icon(Icons.add, size: AppSizes.iconSizeL),
      ),
    );
  }
}

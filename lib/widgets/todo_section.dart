import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/constants.dart';
import 'todo_item.dart';

class TodoSection extends StatelessWidget {
  final String title;
  final List<Todo> todos;
  final Function(Todo) onTodoTap;
  final Function(Todo) onCheckboxChanged;

  const TodoSection({
    super.key,
    required this.title,
    required this.todos,
    required this.onTodoTap,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM,
            vertical: AppSizes.paddingS,
          ),
          child: Text(
            title,
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            boxShadow: AppShadows.cardShadow,
          ),
          child: Column(
            children: todos.map((todo) {
              return Column(
                children: [
                  TodoItem(
                    todo: todo,
                    onTap: () => onTodoTap(todo),
                    onCheckboxChanged: () => onCheckboxChanged(todo),
                  ),
                  if (todo != todos.last)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.background,
                      indent:
                          AppSizes.paddingM +
                          48, // Account for checkbox and padding
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
      ],
    );
  }
}

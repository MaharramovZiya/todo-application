import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onCheckboxChanged;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = todo.status == TodoStatus.completed;
    final isLate = todo.isLate;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onCheckboxChanged,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.success : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCompleted ? AppColors.success : AppColors.textLight,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: AppColors.surface,
                        size: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            // Todo content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? AppColors.textLight : AppColors.textPrimary,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (todo.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppHelpers.formatDueDate(todo.dueDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: isLate ? AppColors.error : AppColors.textSecondary,
                        fontWeight: isLate ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

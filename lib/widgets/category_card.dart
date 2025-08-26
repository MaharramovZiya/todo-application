import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CategoryCard extends StatelessWidget {
  final TodoCategory category;
  final int taskCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.taskCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.iconSizeXL,
                height: AppSizes.iconSizeXL,
                decoration: BoxDecoration(
                  color: AppHelpers.getCategoryColor(category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(
                  AppHelpers.getCategoryIcon(category),
                  color: AppHelpers.getCategoryColor(category),
                  size: AppSizes.iconSizeL,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Text(
                AppHelpers.getCategoryName(category),
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                AppHelpers.formatTaskCount(taskCount),
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

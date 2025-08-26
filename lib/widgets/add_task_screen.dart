import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AddTaskScreen extends StatefulWidget {
  final TodoCategory? initialCategory;
  final Function(Todo) onTaskCreated;

  const AddTaskScreen({
    super.key,
    this.initialCategory,
    required this.onTaskCreated,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  TodoCategory _selectedCategory = TodoCategory.work;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _createTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final todo = Todo(
      title: _titleController.text.trim(),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      dueDate: _selectedDateTime,
      category: _selectedCategory,
    );

    widget.onTaskCreated(todo);
    Navigator.of(context).pop();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // Placeholder for balance
                  Text(
                    'New task',
                    style: AppTextStyles.headline2,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: AppSizes.iconSizeL,
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task title input
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: AppTextStyles.body1,
                        decoration: const InputDecoration(
                          hintText: 'What are you planning?',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(AppSizes.paddingM),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSizes.paddingM),
                    
                    // Date and time input
                    GestureDetector(
                      onTap: _selectDateTime,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          boxShadow: AppShadows.cardShadow,
                        ),
                        padding: const EdgeInsets.all(AppSizes.paddingM),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.textSecondary,
                              size: AppSizes.iconSizeM,
                            ),
                            const SizedBox(width: AppSizes.paddingM),
                            Text(
                              _selectedDateTime != null
                                  ? AppHelpers.formatDateTime(_selectedDateTime!)
                                  : 'May 29, 14:00',
                              style: AppTextStyles.body1.copyWith(
                                color: _selectedDateTime != null
                                    ? AppColors.textPrimary
                                    : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSizes.paddingM),
                    
                    // Note input
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: TextField(
                        controller: _noteController,
                        style: AppTextStyles.body1,
                        decoration: const InputDecoration(
                          hintText: 'Add note',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(AppSizes.paddingM),
                          prefixIcon: Icon(Icons.note, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSizes.paddingM),
                    
                    // Category input
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      child: Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: AppColors.textSecondary,
                            size: AppSizes.iconSizeM,
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<TodoCategory>(
                                value: _selectedCategory,
                                isExpanded: true,
                                items: TodoCategory.values
                                    .where((cat) => cat != TodoCategory.all)
                                    .map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Icon(
                                          AppHelpers.getCategoryIcon(category),
                                          color: AppHelpers.getCategoryColor(category),
                                          size: AppSizes.iconSizeM,
                                        ),
                                        const SizedBox(width: AppSizes.paddingS),
                                        Text(AppHelpers.getCategoryName(category)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Create button
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Create',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

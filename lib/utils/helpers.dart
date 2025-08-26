import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import 'constants.dart';

class AppHelpers {
  // Date formatting
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else if (dateOnly.isAfter(today)) {
      final difference = dateOnly.difference(today).inDays;
      if (difference == 1) {
        return 'Tomorrow';
      } else if (difference <= 7) {
        return DateFormat('EEEE').format(date);
      } else {
        return DateFormat('MMM d').format(date);
      }
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return formatTime(date);
    } else {
      return '${formatDate(date)} · ${formatTime(date)}';
    }
  }
  
  static String formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return '';
    
    final now = DateTime.now();
    final due = dueDate;
    
    if (due.isBefore(now)) {
      return '${formatDate(due)} · ${formatTime(due)}';
    } else if (due.difference(now).inDays == 0) {
      return formatTime(due);
    } else {
      return '${formatDate(due)} · ${formatTime(due)}';
    }
  }
  
  // Category helpers
  static String getCategoryName(TodoCategory category) {
    switch (category) {
      case TodoCategory.all:
        return 'All';
      case TodoCategory.work:
        return 'Work';
      case TodoCategory.music:
        return 'Music';
      case TodoCategory.travel:
        return 'Travel';
      case TodoCategory.study:
        return 'Study';
      case TodoCategory.home:
        return 'Home';
      case TodoCategory.personal:
        return 'Personal';
      case TodoCategory.shopping:
        return 'Shopping';
    }
  }
  
  static IconData getCategoryIcon(TodoCategory category) {
    switch (category) {
      case TodoCategory.all:
        return Icons.dashboard;
      case TodoCategory.work:
        return Icons.work;
      case TodoCategory.music:
        return Icons.headphones;
      case TodoCategory.travel:
        return Icons.flight;
      case TodoCategory.study:
        return Icons.book;
      case TodoCategory.home:
        return Icons.home;
      case TodoCategory.personal:
        return Icons.palette;
      case TodoCategory.shopping:
        return Icons.shopping_cart;
    }
  }
  
  static Color getCategoryColor(TodoCategory category) {
    switch (category) {
      case TodoCategory.all:
        return AppColors.primary;
      case TodoCategory.work:
        return AppColors.workColor;
      case TodoCategory.music:
        return AppColors.musicColor;
      case TodoCategory.travel:
        return AppColors.travelColor;
      case TodoCategory.study:
        return AppColors.studyColor;
      case TodoCategory.home:
        return AppColors.homeColor;
      case TodoCategory.personal:
        return AppColors.personalColor;
      case TodoCategory.shopping:
        return AppColors.shoppingColor;
    }
  }
  
  // Task count formatting
  static String formatTaskCount(int count) {
    if (count == 0) return 'No Tasks';
    if (count == 1) return '1 Task';
    return '$count Tasks';
  }
  
  // Status helpers
  static String getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Pending';
      case TodoStatus.completed:
        return 'Completed';
      case TodoStatus.late:
        return 'Late';
    }
  }
  
  static Color getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return AppColors.textSecondary;
      case TodoStatus.completed:
        return AppColors.success;
      case TodoStatus.late:
        return AppColors.error;
    }
  }
}

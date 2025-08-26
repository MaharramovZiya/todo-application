import 'package:uuid/uuid.dart';

enum TodoCategory {
  all,
  work,
  music,
  travel,
  study,
  home,
  personal,
  shopping,
}

enum TodoStatus {
  pending,
  completed,
  late,
}

class Todo {
  final String id;
  final String title;
  final String? note;
  final DateTime? dueDate;
  final TodoCategory category;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  Todo({
    String? id,
    required this.title,
    this.note,
    this.dueDate,
    required this.category,
    this.status = TodoStatus.pending,
    DateTime? createdAt,
    this.completedAt,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  Todo copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? dueDate,
    TodoCategory? category,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isLate {
    if (dueDate == null || status == TodoStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year && now.month == due.month && now.day == due.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'dueDate': dueDate?.toIso8601String(),
      'category': category.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      category: TodoCategory.values[json['category']],
      status: TodoStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }
}

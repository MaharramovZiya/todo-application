import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  TodoCategory _selectedCategory = TodoCategory.all;
  
  List<Todo> get todos => _todos;
  TodoCategory get selectedCategory => _selectedCategory;
  
  // Get todos by category
  List<Todo> getTodosByCategory(TodoCategory category) {
    if (category == TodoCategory.all) {
      return _todos;
    }
    return _todos.where((todo) => todo.category == category).toList();
  }
  
  // Get todos by status
  List<Todo> getTodosByStatus(TodoStatus status) {
    return _todos.where((todo) => todo.status == status).toList();
  }
  
  // Get late todos
  List<Todo> get lateTodos {
    return _todos.where((todo) => todo.isLate).toList();
  }
  
  // Get today todos
  List<Todo> get todayTodos {
    return _todos.where((todo) => todo.isToday).toList();
  }
  
  // Get completed todos
  List<Todo> get completedTodos {
    return _todos.where((todo) => todo.status == TodoStatus.completed).toList();
  }
  
  // Get pending todos
  List<Todo> get pendingTodos {
    return _todos.where((todo) => todo.status == TodoStatus.pending).toList();
  }
  
  // Get task count by category
  int getTaskCountByCategory(TodoCategory category) {
    if (category == TodoCategory.all) {
      return _todos.length;
    }
    return _todos.where((todo) => todo.category == category).length;
  }
  
  // Set selected category
  void setSelectedCategory(TodoCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  // Add todo
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await _saveTodos();
    notifyListeners();
  }
  
  // Update todo
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      await _saveTodos();
      notifyListeners();
    }
  }
  
  // Delete todo
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _saveTodos();
    notifyListeners();
  }
  
  // Toggle todo completion
  Future<void> toggleTodoCompletion(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final newStatus = todo.status == TodoStatus.completed 
          ? TodoStatus.pending 
          : TodoStatus.completed;
      
      _todos[index] = todo.copyWith(
        status: newStatus,
        completedAt: newStatus == TodoStatus.completed ? DateTime.now() : null,
      );
      
      await _saveTodos();
      notifyListeners();
    }
  }
  
  // Load todos from storage
  Future<void> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getStringList('todos') ?? [];
      
      _todos = todosJson
          .map((json) => Todo.fromJson(jsonDecode(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }
  
  // Save todos to storage
  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = _todos
          .map((todo) => jsonEncode(todo.toJson()))
          .toList();
      
      await prefs.setStringList('todos', todosJson);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }
  
  // Initialize with sample data
  Future<void> initializeWithSampleData() async {
    if (_todos.isEmpty) {
      final sampleTodos = [
        Todo(
          title: 'Call Max',
          dueDate: DateTime.now().subtract(const Duration(hours: 2)),
          category: TodoCategory.work,
          status: TodoStatus.late,
        ),
        Todo(
          title: 'Practice piano',
          dueDate: DateTime.now().add(const Duration(hours: 6)),
          category: TodoCategory.music,
        ),
        Todo(
          title: 'Learn Spanish',
          dueDate: DateTime.now().add(const Duration(hours: 7)),
          category: TodoCategory.study,
        ),
        Todo(
          title: 'Finalize presentation',
          dueDate: DateTime.now().subtract(const Duration(hours: 3)),
          category: TodoCategory.work,
          status: TodoStatus.completed,
          completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Todo(
          title: 'Book flight tickets',
          dueDate: DateTime.now().add(const Duration(days: 5)),
          category: TodoCategory.travel,
        ),
        Todo(
          title: 'Buy groceries',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          category: TodoCategory.home,
        ),
        Todo(
          title: 'Review code',
          dueDate: DateTime.now().add(const Duration(hours: 3)),
          category: TodoCategory.work,
        ),
        Todo(
          title: 'Listen to new album',
          dueDate: DateTime.now().add(const Duration(hours: 1)),
          category: TodoCategory.music,
        ),
      ];
      
      _todos.addAll(sampleTodos);
      await _saveTodos();
      notifyListeners();
    }
  }
}

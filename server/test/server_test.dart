import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000/api/v1')); // 기본 URL을 실제 API URL로 변경

  Future<int> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/user/', data: userData);
      print('User created: ${response.data}\n');
      //print('User created: ${response.data!['result']!['userId']}');
      return response.data != null ? response.data!['result']!['userId'] as int : throw Exception('User ID not found');
    } catch (e) {
      print('Failed to create user: $e');
      throw Exception('Failed to create user');
    }
  }

  Future<void> getUser(int userId) async {
    try {
      final response = await _dio.get('/user/$userId');
      print('User details: ${response.data}\n');
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      final response = await _dio.delete('/user/$userId');
      print('User deleted: ${response.data}\n');
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put('/user/$userId', data: updatedData);
      print('User updated: ${response.data}');
      final userService = UserService();
      await userService.getUser(userId);
    } catch (e) {
      print('Failed to update user: $e');
    }
  }
}

void main() async {
  final userService = UserService();
  int userId;

  // Create a new user
  userId = await userService.createUser({
    'name': 'John Doe',
    'email': 'johndoe@example.com',
  });

  // Get a user by ID
  await userService.getUser(userId);

  // Update user information
  await userService.updateUser(userId, {
    'name': 'Kane Doe',
    'email': 'kanedoe@example.co.kr',
  });

  // Delete a user by ID
  await userService.deleteUser(userId);
}
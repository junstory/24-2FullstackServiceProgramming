import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3000/api/v1')); // 기본 URL을 실제 API URL로 변경

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/user/', data: userData);
      print('User created: ${response.data}');
    } catch (e) {
      print('Failed to create user: $e');
    }
  }

  Future<void> getUser(String userId) async {
    try {
      final response = await _dio.get('/user/$userId');
      print('User details: ${response.data}');
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await _dio.delete('/user/$userId');
      print('User deleted: ${response.statusCode}');
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put('/user/$userId', data: updatedData);
      print('User updated: ${response.data}');
    } catch (e) {
      print('Failed to update user: $e');
    }
  }
}

void main() async {
  final userService = UserService();

  // Create a new user
  await userService.createUser({
    'name': 'John Doe',
    'email': 'johndoe@example.com',
  });

  // Get a user by ID
  await userService.getUser('30');

  // Update user information
  await userService.updateUser('123', {
    'name': 'Jane Doe',
    'email': 'janedoe@example.com',
  });

  // Delete a user by ID
  await userService.deleteUser('123');
}
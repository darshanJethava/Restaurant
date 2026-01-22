import 'package:restaurant/Model/user_Model.dart';
import 'package:restaurant/Services/user_services.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class UserRepo {
  final UserServices userServices = UserServices();

  Future<List<User>> fetchUser() async {
    try {
      final data = await userServices.getAlluser();

      if (data.isEmpty) {
        return [];
      }

      return data.map((e) {
        try {
          return User.fromJson(e as Map<String, dynamic>);
        } catch (e) {
          throw ParseException(
            message: 'Failed to parse user data',
            originalException: e,
          );
        }
      }).toList();
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to fetch users: ${e.message}',
        originalException: e,
      );
    } on ParseException catch (e) {
      throw RepositoryException(
        message: 'Failed to parse users: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error fetching users',
        originalException: e,
      );
    }
  }

 
  Future<void> addUser(User user) async {
    try {
      if (user.id.isEmpty) {
        throw RepositoryException(message: 'User ID cannot be empty');
      }

      await userServices.createuser(user.toJson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to add user: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error adding user',
        originalException: e,
      );
    }
  }

  /// Update an existing user
  /// Throws [RepositoryException] if operation fails
  Future<void> updateUser(User user) async {
    try {
      if (user.id.isEmpty) {
        throw RepositoryException(
          message: 'User ID cannot be empty for update',
        );
      }

      await userServices.updateuser(user.id, user.toJson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to update user: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error updating user',
        originalException: e,
      );
    }
  }

  /// Delete a user
  /// Throws [RepositoryException] if operation fails
  Future<void> deleteUser(String id) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(
          message: 'User ID cannot be empty for deletion',
        );
      }

      await userServices.deleteuser(id);
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to delete user: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error deleting user',
        originalException: e,
      );
    }
  }
}

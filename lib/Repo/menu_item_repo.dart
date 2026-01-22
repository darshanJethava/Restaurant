import 'package:restaurant/Model/menu_item_model.dart';
import 'package:restaurant/Services/menu_item_services.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class MenuItemRepo {
  final MenuItemServices services = MenuItemServices();

  Future<List<MenuItem>> fetchAllMenuItems() async {
    try {
      final data = await services.getAllMenuItems();
      return data.map((e) {
        try {
          return MenuItem.fromJson(e as Map<String, dynamic>);
        } catch (e) {
          throw ParseException(
            message: 'Failed to parse menu item data',
            originalException: e,
          );
        }
      }).toList();
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to fetch menu items: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error fetching menu items',
        originalException: e,
      );
    }
  }

  Future<void> addMenuItem(MenuItem item) async {
    try {
      if (item.menu_item_id.isEmpty) {
        throw RepositoryException(message: 'Menu item ID cannot be empty');
      }

      await services.createMenuItem(item.toJson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to add menu item: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error adding menu item',
        originalException: e,
      );
    }
  }

  Future<void> updateMenuItem(String id, MenuItem item) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Menu item ID cannot be empty');
      }

      await services.updateMenuItem(id, item.toJson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to update menu item: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error updating menu item',
        originalException: e,
      );
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Menu item ID cannot be empty');
      }

      await services.deleteMenuItem(id);
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to delete menu item: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error deleting menu item',
        originalException: e,
      );
    }
  }
}

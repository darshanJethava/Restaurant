import 'package:restaurant/Model/table_Model.dart';
import 'package:restaurant/Services/table_services.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class TableRepo {
  final TableServices services = TableServices();

  Future<List<Table>> fetchAllTables() async {
    try {
      final data = await services.getAllTables();
      return data.map((e) {
        try {
          return Table.fromJson(e as Map<String, dynamic>);
        } catch (e) {
          throw ParseException(
            message: 'Failed to parse table data',
            originalException: e,
          );
        }
      }).toList();
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to fetch tables: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error fetching tables',
        originalException: e,
      );
    }
  }

  Future<void> addTable(Table table) async {
    try {
      if (table.table_no.isEmpty) {
        throw RepositoryException(message: 'Table number cannot be empty');
      }

      await services.createTable({
        'table_no': table.table_no,
        'Table_Capacity': table.Table_Capacity,
        'Table_statue': table.Table_statue,
      });
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to add table: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error adding table',
        originalException: e,
      );
    }
  }

  Future<void> updateTable(String id, Table table) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Table ID cannot be empty');
      }

      await services.updateTable(id, {
        'table_no': table.table_no,
        'Table_Capacity': table.Table_Capacity,
        'Table_statue': table.Table_statue,
      });
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to update table: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error updating table',
        originalException: e,
      );
    }
  }

  Future<void> deleteTable(String id) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Table ID cannot be empty');
      }

      await services.deleteTable(id);
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to delete table: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error deleting table',
        originalException: e,
      );
    }
  }
}

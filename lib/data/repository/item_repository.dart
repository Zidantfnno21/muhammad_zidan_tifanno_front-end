import 'package:mobile_test_siscom/utils/result.dart';

import '../local/app_database.dart';
import '../local/entity/item.dart';
import '../local/entity/item_category.dart';

class ItemRepository {
  final AppDatabase _appDatabase;

  ItemRepository({required AppDatabase appDatabase})
      : _appDatabase = appDatabase;

  Future<Result<int?>> countItem() async {
    try {
      final data = await _appDatabase.itemDao.getTotalItemCount();
      return Result.ok(data);
    } catch (e) {
      return Result.error(Exception('Failed to count item $e'));
    }
  }

  Future<Result<List<ItemCategory>>> getCategories() async {
    try {
      final data = await _appDatabase.itemCategoryDao.getAllItemCategory();
      return Result.ok(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch categories: $e'));
    }
  }

  Future<Result<ItemCategory?>> getCategoryById(int categoryId) async {
    try {
      final category =
          await _appDatabase.itemCategoryDao.findCategoryById(categoryId);
      return Result.ok(category);
    } catch (e) {
      return Result.error(Exception('Failed to fetch category: $e'));
    }
  }

  Future<Result<List<Item>>> getPaginatedItems(
      {required int page, int limit = 20}) async {
    try {
      final offset = (page - 1) * limit;
      final data = await _appDatabase.itemDao.getItemsPaginated(limit, offset);
      return Result.ok(data);
    } catch (e) {
      return Result.error(Exception('Failed to fetch paginated items: $e'));
    }
  }

  Future<Result<Item?>> getItemById(int id) async {
    try {
      final item = await _appDatabase.itemDao.getItemById(id);
      return Result.ok(item);
    } catch (e) {
      return Result.error(Exception('Failed to fetch item: $e'));
    }
  }

  Future<Result<void>> createNewItem(Item item) async {
    try {
      await _appDatabase.itemDao.insertItem(item);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Failed to create new item: $e'));
    }
  }

  Future<Result<void>> updateItem(Item newItem) async {
    try {
      await _appDatabase.itemDao.updateItem(newItem);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Failed to update item: $e'));
    }
  }

  Future<Result<void>> deleteItem(List<Item> items) async {
    try {
      for (final item in items) {
        await _appDatabase.itemDao.deleteItem(item);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Failed to delete item(s): $e'));
    }
  }

  Future<Result<List<Item>>> searchItems({
    required String query,
    required int limit,
    required int offset,
  }) async {
    try {
      final items =
          await _appDatabase.itemDao.searchItems('%$query%', limit, offset);
      return Result.ok(items);
    } catch (e) {
      return Result.error(Exception('Failed to search items: $e'));
    }
  }

  Future<Result<int>> countMatchingItems(String query) async {
    try {
      final count = await _appDatabase.itemDao.countMatchingItems('%$query%');
      return Result.ok(count ?? 0);
    } catch (e) {
      return Result.error(Exception('Failed to count matching items: $e'));
    }
  }
}

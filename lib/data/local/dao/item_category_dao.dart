import 'package:floor/floor.dart';
import 'package:mobile_test_siscom/data/local/entity/item_category.dart';

@dao
abstract class ItemCategoryDao {
  @Query('SELECT * FROM item_category')
  Future<List<ItemCategory>> getAllItemCategory();

  @Query('SELECT * FROM item_category WHERE id = :id')
  Future<ItemCategory?> findCategoryById(int id);

  @Query('DELETE FROM item_category')
  Future<void> deleteAllItemCategory();
}
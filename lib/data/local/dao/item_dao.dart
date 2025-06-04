import 'package:floor/floor.dart';
import 'package:mobile_test_siscom/data/local/entity/item.dart';

@dao
abstract class ItemDao {
  @Query('SELECT * FROM item')
  Future<List<Item>> getAllItem();

  @Query('SELECT * FROM item WHERE id = :id')
  Future<Item?> getItemById(int id);

  @Query('SELECT * FROM item ORDER BY id LIMIT :limit OFFSET :offset')
  Future<List<Item>> getItemsPaginated(int limit, int offset);

  @Query('SELECT COUNT(*) FROM item')
  Future<int?> getTotalItemCount();

  @Query(
      'SELECT * FROM item WHERE itemName LIKE :query LIMIT :limit OFFSET :offset')
  Future<List<Item>> searchItems(String query, int limit, int offset);

  @Query('SELECT COUNT(*) FROM item WHERE itemName LIKE :query')
  Future<int?> countMatchingItems(String query);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateItem(Item item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertItem(Item item);

  @delete
  Future<void> deleteItem(Item item);

  @Query('DELETE FROM item')
  Future<void> deleteAllItem();
}

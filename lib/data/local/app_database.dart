import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:mobile_test_siscom/data/local/dao/item_category_dao.dart';
import 'package:mobile_test_siscom/data/local/dao/item_dao.dart';

import 'entity/item.dart';
import 'entity/item_category.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Item, ItemCategory])
abstract class AppDatabase extends FloorDatabase {
  ItemDao get itemDao;
  ItemCategoryDao get itemCategoryDao;

  Future<void> clearAllTables() async {
    await itemDao.deleteAllItem();
    await itemCategoryDao.deleteAllItemCategory();
  }

  static Future<AppDatabase> createDatabase() {
    final callback = Callback(
      onCreate: (database, version) async {
        final itemCategories = [
          ItemCategory(id: 1, name: 'Elektronik'),
          ItemCategory(id: 2, name: 'Minuman & Makanan'),
          ItemCategory(id: 3, name: 'Alat Tulis'),
          ItemCategory(id: 4, name: 'Kecantikan'),
          ItemCategory(id: 5, name: 'Hobi'),
          ItemCategory(id: 6, name: 'Buku'),
          ItemCategory(id: 7, name: 'Perlengkapan Rumah Tangga'),
          ItemCategory(id: 8, name: 'Fashion'),
          ItemCategory(id: 9, name: 'Furnitur'),
        ];

        for (var category in itemCategories) {
          await database.insert(
            'item_category',
            {'id': category.id, 'name': category.name},
          );
        }
      },
    );

    return $FloorAppDatabase.databaseBuilder('app_database.db')
        .addCallback(callback)
        .build();
  }
}
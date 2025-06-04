// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ItemDao? _itemDaoInstance;

  ItemCategoryDao? _itemCategoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `item` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `itemName` TEXT NOT NULL, `categoryId` INTEGER NOT NULL, `stock` INTEGER NOT NULL, `itemGroup` TEXT NOT NULL, `price` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `item_category` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }

  @override
  ItemCategoryDao get itemCategoryDao {
    return _itemCategoryDaoInstance ??=
        _$ItemCategoryDao(database, changeListener);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'item',
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'itemName': item.itemName,
                  'categoryId': item.categoryId,
                  'stock': item.stock,
                  'itemGroup': item.itemGroup,
                  'price': item.price
                }),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'itemName': item.itemName,
                  'categoryId': item.categoryId,
                  'stock': item.stock,
                  'itemGroup': item.itemGroup,
                  'price': item.price
                }),
        _itemDeletionAdapter = DeletionAdapter(
            database,
            'item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'itemName': item.itemName,
                  'categoryId': item.categoryId,
                  'stock': item.stock,
                  'itemGroup': item.itemGroup,
                  'price': item.price
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  final DeletionAdapter<Item> _itemDeletionAdapter;

  @override
  Future<List<Item>> getAllItem() async {
    return _queryAdapter.queryList('SELECT * FROM item',
        mapper: (Map<String, Object?> row) => Item(
            id: row['id'] as int,
            itemName: row['itemName'] as String,
            categoryId: row['categoryId'] as int,
            stock: row['stock'] as int,
            itemGroup: row['itemGroup'] as String,
            price: row['price'] as int));
  }

  @override
  Future<Item?> getItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM item WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Item(
            id: row['id'] as int,
            itemName: row['itemName'] as String,
            categoryId: row['categoryId'] as int,
            stock: row['stock'] as int,
            itemGroup: row['itemGroup'] as String,
            price: row['price'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Item>> getItemsPaginated(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM item ORDER BY id LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => Item(
            id: row['id'] as int,
            itemName: row['itemName'] as String,
            categoryId: row['categoryId'] as int,
            stock: row['stock'] as int,
            itemGroup: row['itemGroup'] as String,
            price: row['price'] as int),
        arguments: [limit, offset]);
  }

  @override
  Future<int?> getTotalItemCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM item',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Item>> searchItems(
    String query,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM item WHERE itemName LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => Item(
            id: row['id'] as int,
            itemName: row['itemName'] as String,
            categoryId: row['categoryId'] as int,
            stock: row['stock'] as int,
            itemGroup: row['itemGroup'] as String,
            price: row['price'] as int),
        arguments: [query, limit, offset]);
  }

  @override
  Future<int?> countMatchingItems(String query) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM item WHERE itemName LIKE ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [query]);
  }

  @override
  Future<void> deleteAllItem() async {
    await _queryAdapter.queryNoReturn('DELETE FROM item');
  }

  @override
  Future<void> insertItem(Item item) async {
    await _itemInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(Item item) async {
    await _itemUpdateAdapter.update(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItem(Item item) async {
    await _itemDeletionAdapter.delete(item);
  }
}

class _$ItemCategoryDao extends ItemCategoryDao {
  _$ItemCategoryDao(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<ItemCategory>> getAllItemCategory() async {
    return _queryAdapter.queryList('SELECT * FROM item_category',
        mapper: (Map<String, Object?> row) =>
            ItemCategory(id: row['id'] as int, name: row['name'] as String));
  }

  @override
  Future<ItemCategory?> findCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM item_category WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            ItemCategory(id: row['id'] as int, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllItemCategory() async {
    await _queryAdapter.queryNoReturn('DELETE FROM item_category');
  }
}

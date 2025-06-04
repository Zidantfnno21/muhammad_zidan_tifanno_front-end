
import '../data/local/app_database.dart';
import 'package:get/get.dart';

import '../data/repository/item_repository.dart';
import '../ui/list_stock/controllers/list_stock_controller.dart';
import '../ui/detail_stock/controllers/detail_stock_controller.dart';

class AppBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final db = await AppDatabase.createDatabase();

    Get.put<AppDatabase>(db, permanent: true);
    Get.put<ItemRepository>(ItemRepository(appDatabase: db));
    Get.put(ListStockController(Get.find<ItemRepository>()));
    Get.lazyPut(() => DetailStockController(Get.find<ItemRepository>()));
  }
}

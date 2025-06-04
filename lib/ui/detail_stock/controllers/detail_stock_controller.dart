import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/local/entity/item.dart';
import '../../../data/local/entity/item_category.dart';
import '../../../data/repository/item_repository.dart';
import '../../../utils/result.dart';

class DetailStockController extends GetxController {
  final ItemRepository _itemRepository;

  DetailStockController(this._itemRepository);

  final Rx<Item?> currentItem = Rx<Item?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  final RxList<ItemCategory> itemCategoryList = <ItemCategory>[].obs;
  final RxInt selectedKategoriId = RxInt(0);

  final Rx<String> selectedKelompok = ''.obs;

  void setKelompok(String value) {
    selectedKelompok.value = value;
  }

  final List<String> kelompokList = [
    'Smartphone',
    'Hair Dryer',
    'Sapu',
    'Moisturizer',
    'Bakso',
    'Pulpen',
    'Sketch Book',
    'Celana',
    'Meja Portable'
  ];

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await _itemRepository.getCategories();
    if (result is Ok<List<ItemCategory>>) {
      itemCategoryList.value = result.value;
      if (itemCategoryList.isNotEmpty) {
        selectedKategoriId.value = itemCategoryList.first.id;
      }
    } else if (result is Error<List<ItemCategory>>) {
      errorMessage.value = result.error.toString();
    }

    isLoading.value = false;
  }

  Future<void> fetchItemById(int id) async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await _itemRepository.getItemById(id);
    if (result is Ok<Item?>) {
      currentItem.value = result.value;
      if (result.value != null) {
        selectedKategoriId.value = result.value!.categoryId;
        selectedKelompok.value = result.value!.itemGroup;
      }
    } else if (result is Error<Item?>) {
      errorMessage.value = result.error.toString();
    }

    isLoading.value = false;
  }

  Future<void> createItem(Item item, VoidCallback onSuccess) async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await _itemRepository.createNewItem(item);
    if (result is Ok<void>) {
      onSuccess();
    } else if (result is Error<void>) {
      errorMessage.value = result.error.toString();
    }

    isLoading.value = false;
  }

  Future<void> updateItem(Item item, VoidCallback onSuccess) async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await _itemRepository.updateItem(item);
    if (result is Ok<void>) {
      currentItem.value = item;
      onSuccess();
    } else if (result is Error<void>) {
      errorMessage.value = result.error.toString();
    }

    isLoading.value = false;
  }

  void clear() {
    currentItem.value = null;
    errorMessage.value = "";
    if (itemCategoryList.isNotEmpty) {
      selectedKategoriId.value = itemCategoryList.first.id;
    }
  }
}

import 'package:get/get.dart';
import 'package:mobile_test_siscom/data/local/entity/item_category.dart';

import '../../../data/local/entity/item.dart';
import '../../../data/repository/item_repository.dart';
import '../../../utils/result.dart';

class ListStockController extends GetxController {
  final ItemRepository _repository;

  ListStockController(this._repository);

  final RxInt currentPage = 1.obs;
  final RxList<Item> items = <Item>[].obs;

  final RxBool isInitialLoading = false.obs;
  final RxBool isPageLoading = false.obs;
  final RxString? errorMessage = RxString("");

  final RxBool isLastPage = false.obs;

  static const int pageSize = 20;

  final RxBool isEditMode = false.obs;
  final RxSet<int> selectedItemIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialItems();
    fetchItemCount();
  }

  void onResume() {
    currentPage.value = 1;
    isLastPage.value = false;
    selectedItemIds.clear();
    isEditMode.value = false;
    fetchInitialItems();
    fetchItemCount();
  }

  final RxInt itemCount = 0.obs;

  void toggleEditMode() {
    isEditMode.toggle();
    if (!isEditMode.value) {
      selectedItemIds.clear();
    }
  }

  void toggleItemSelection(int id) {
    if (selectedItemIds.contains(id)) {
      selectedItemIds.remove(id);
    } else {
      selectedItemIds.add(id);
    }
    update();
  }

  bool isSelected(int id) => selectedItemIds.contains(id);

  void toggleSelectAll(bool selectAll) {
    if (selectAll) {
      selectedItemIds.addAll(items.map((item) => item.id));
    } else {
      selectedItemIds.clear();
    }
    update();
  }

  bool get isAllSelected => selectedItemIds.length == items.length;

  Future<void> fetchItemCount() async {
    final result = await _repository.countItem();

    if (result is Ok<int?>) {
      itemCount.value = result.value ?? 0;
    } else if (result is Error<int?>) {
      itemCount.value = 0;
    }
  }

  Future<void> fetchInitialItems() async {
    isInitialLoading.value = true;
    errorMessage!.value = "";
    currentPage.value = 1;
    isLastPage.value = false;

    final result = await _repository.getPaginatedItems(
      page: currentPage.value,
      limit: pageSize,
    );

    if (result is Ok<List<Item>>) {
      final fetchedItems = result.value;
      items.value = fetchedItems;
      if (fetchedItems.length < pageSize) {
        isLastPage.value = true;
      }
    } else if (result is Error<List<Item>>) {
      errorMessage!.value = result.error.toString();
    }
    isInitialLoading.value = false;
  }

  Future<void> loadNextPage() async {
    if (isPageLoading.value || isLastPage.value) return;

    isPageLoading.value = true;
    errorMessage!.value = "";
    currentPage.value += 1;

    final result = await _repository.getPaginatedItems(
      page: currentPage.value,
      limit: pageSize,
    );

    if (result is Ok<List<Item>>) {
      final fetchedItems = result.value;
      items.addAll(fetchedItems);
      if (fetchedItems.length < pageSize) {
        isLastPage.value = true;
      }
    } else if (result is Error<List<Item>>) {
      errorMessage!.value = result.error.toString();
      currentPage.value -= 1;
    }
    isPageLoading.value = false;
  }

  Future<void> deleteSelectedItems() async {
    final selectedItems =
        items.where((item) => selectedItemIds.contains(item.id)).toList();

    isPageLoading.value = true;
    final result = await _repository.deleteItem(selectedItems);

    if (result is Ok<void>) {
      fetchInitialItems();
      fetchItemCount();
      isEditMode.value = false;
    } else if (result is Error<void>) {
      errorMessage!.value = result.error.toString();
    }
    isPageLoading.value = false;
  }

  Future<void> deleteSingleItem(Item item) async {
    isPageLoading.value = true;
    final result = await _repository.deleteItem([item]);

    if (result is Ok<void>) {
      fetchInitialItems();
      fetchItemCount();
    } else if (result is Error<void>) {
      errorMessage!.value = result.error.toString();
    }
    isPageLoading.value = false;
  }

  bool get isEmpty =>
      items.isEmpty && !isInitialLoading.value && errorMessage!.value.isEmpty;

  Future<ItemCategory?> getCategoryById(int categoryId) async {
    final result = await _repository.getCategoryById(categoryId);

    if (result is Ok<ItemCategory?>) {
      return result.value;
    } else if (result is Error<ItemCategory?>) {
      return null;
    }
    return null;
  }
}

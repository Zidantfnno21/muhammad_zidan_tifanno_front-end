import 'package:get/get.dart';

import '../../../data/local/entity/item.dart';
import '../../../data/repository/item_repository.dart';
import '../../../utils/result.dart';

class SearchController extends GetxController {
  final ItemRepository _repository;

  SearchController(this._repository);

  final RxList<Item> items = <Item>[].obs;
  final RxBool isInitialLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<String?> errorMessage = (null as String?).obs;

  final RxInt itemCount = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLastPage = false.obs;

  final int pageSize = 10;
  String _currentQuery = '';

  bool get isEmpty => items.isEmpty && !isInitialLoading.value;

  void onResume() {
    if (_currentQuery.isNotEmpty) {
      search(_currentQuery);
    }
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    currentPage.value = 1;
    isLastPage.value = false;
    items.clear();
    errorMessage.value = null;
    isInitialLoading.value = true;

    final results = await Future.wait([
      _repository.searchItems(
        query: query,
        limit: pageSize,
        offset: 0,
      ),
      _repository.countMatchingItems(query),
    ]);

    final listResult = results[0];
    final countResult = results[1];

    if (listResult is Ok<List<Item>>) {
      items.addAll(listResult.value);
      isLastPage.value = listResult.value.length < pageSize;
    } else if (listResult is Error<List<Item>>) {
      errorMessage.value = listResult.error.toString();
    }

    if (countResult is Ok<int>) {
      itemCount.value = countResult.value;
    } else if (countResult is Error<int>) {
      errorMessage.value = countResult.error.toString();
      itemCount.value = 0;
    }

    isInitialLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || isLastPage.value) return;

    isLoadingMore.value = true;
    currentPage.value += 1;

    final result = await _repository.searchItems(
      query: _currentQuery,
      limit: pageSize,
      offset: (currentPage.value - 1) * pageSize,
    );

    if (result is Ok<List<Item>>) {
      final newItems = result.value;
      items.addAll(newItems);
      if (newItems.length < pageSize) {
        isLastPage.value = true;
      }
    } else if (result is Error<List<Item>>) {
      errorMessage.value = result.error.toString();
    }

    isLoadingMore.value = false;
  }
}

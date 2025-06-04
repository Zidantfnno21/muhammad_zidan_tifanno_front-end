import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repository/item_repository.dart';
import '../../../routing/routes.dart';
import '../../../utils/currency_utils.dart';
import '../../detail_stock/model/detail_stock_args.dart';
import '../controllers/search_controller.dart' as custom;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final custom.SearchController controller =
      Get.put(custom.SearchController(Get.find<ItemRepository>()));
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    Get.delete<custom.SearchController>();
    super.dispose();
  }

  void _handleSearch(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata kunci pencarian tidak boleh kosong')),
      );
    } else {
      controller.search(query);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Cari barang...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _handleSearch(context),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _handleSearch(context),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                child: Text(
                  "${controller.itemCount} Data Cocok",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
            child: Obx(() {
              if (controller.isInitialLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value != null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Error: ${controller.errorMessage.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              if (controller.isEmpty) {
                return const Center(child: Text("Tidak ditemukan."));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (!controller.isLastPage.value &&
                      scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: controller.items.length +
                      (controller.isLastPage.value ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index < controller.items.length) {
                      final item = controller.items[index];
                      return InkWell(
                        onTap: () {
                          context.pushNamed(
                            Routes.detailStock,
                            extra: DetailStockArgs(
                              id: item.id,
                              onPop: () => controller.onResume(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.stock} Stok',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyUtils.formatToIdr(item.price),
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

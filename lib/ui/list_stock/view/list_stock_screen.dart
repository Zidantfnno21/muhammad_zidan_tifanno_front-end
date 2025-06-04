import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_test_siscom/routing/routes.dart';
import 'package:mobile_test_siscom/ui/detail_stock/model/detail_stock_args.dart';
import 'package:mobile_test_siscom/widgets/list_item.dart';

import '../../../data/repository/item_repository.dart';
import '../controllers/list_stock_controller.dart';
import '../widget/item_detail_sheet.dart';

class ListStockScreen extends StatefulWidget {
  const ListStockScreen({super.key});

  @override
  State<ListStockScreen> createState() => _ListStockScreenState();
}

class _ListStockScreenState extends State<ListStockScreen>
    with WidgetsBindingObserver {
  late final ListStockController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ListStockController(Get.find<ItemRepository>()));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.onResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text("List Stock Barang"),
        actions: [
          Obx(() => controller.isEditMode.value
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.select_all),
                      onPressed: () =>
                          controller.toggleSelectAll(!controller.isAllSelected),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: controller.selectedItemIds.isEmpty
                          ? null
                          : () => controller.deleteSelectedItems(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => controller.toggleEditMode(),
                    ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => context.pushNamed(
                        Routes.searchStock,
                        extra: {'onPop': () => controller.onResume()},
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.pushNamed(
                        Routes.detailStock,
                        extra: DetailStockArgs(
                          onPop: controller.onResume
                        )
                      ),
                    ),
                  ],
                )),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '${controller.itemCount} Data Ditampilkan',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        controller.toggleEditMode();
                      },
                      child: Text(
                        controller.isEditMode.value ? "Selesai" : "Edit Data",
                        style: const TextStyle(
                          color: Color(0xFF2F80ED),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isInitialLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage?.value != "") {
                  return Center(
                    child: Text(
                      'Error: ${controller.errorMessage?.value ?? "Something Went Wrong!"}',
                    ),
                  );
                }

                if (controller.isEmpty) {
                  return const Center(child: Text("No items found."));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!controller.isLastPage.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.loadNextPage();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: controller.items.length +
                        (controller.isLastPage.value ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index < controller.items.length) {
                        final item = controller.items[index];
                        return ListItem(
                          item: item,
                          controller: controller,
                          onClick: () {
                            if (controller.isEditMode.value) {
                              controller.toggleItemSelection(item.id);
                            } else {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                builder: (_) => ItemDetailSheet(
                                  item: item,
                                  onPop: () => controller.onResume(),
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
            Obx(() {
              if (!controller.isEditMode.value) return const SizedBox();

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: controller.isAllSelected,
                          onChanged: (value) {
                            controller.toggleSelectAll(value ?? false);
                          },
                        ),
                        const Text("Pilih Semua")
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: controller.selectedItemIds.isEmpty
                            ? null
                            : controller.deleteSelectedItems,
                        icon: const Icon(Icons.delete),
                        label: const Text("Hapus Barang"),
                      ),
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

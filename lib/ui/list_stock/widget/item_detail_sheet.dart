import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_test_siscom/data/local/entity/item_category.dart';
import 'package:mobile_test_siscom/routing/routes.dart';
import 'package:mobile_test_siscom/ui/detail_stock/model/detail_stock_args.dart';

import '../../../data/local/entity/item.dart';
import '../../../utils/currency_utils.dart';
import '../controllers/list_stock_controller.dart';

class ItemDetailSheet extends StatelessWidget {
  final Item item;
  final VoidCallback? onPop;

  const ItemDetailSheet({
    super.key,
    required this.item,
    this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ListStockController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        runSpacing: 16,
        children: [
          FutureBuilder<ItemCategory?>(
            future: controller.getCategoryById(item.categoryId),
            builder: (context, snapshot) {
              String categoryName = "Loading...";

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  categoryName = snapshot.data?.name ?? "Unknown Category";
                } else {
                  categoryName = "Unknown Category";
                }
              }

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFE2E8F0), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Nama Barang", item.itemName),
                        const SizedBox(height: 8),
                        _buildDetailRow("Kategori", categoryName),
                        const SizedBox(height: 8),
                        _buildDetailRow("Kelompok", item.itemGroup),
                        const SizedBox(height: 8),
                        _buildDetailRow("Stok", item.stock.toString()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildDetailRow('Harga', CurrencyUtils.formatToIdr(item.price)),
                    ),
                  )
                ],
              );
            },
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      Routes.detailStock,
                      extra: DetailStockArgs(
                        id: item.id,
                        onPop: onPop,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF2F80ED)),
                  label: const Text("Edit Barang",
                      style: TextStyle(color: Color(0xFF2F80ED))),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await controller.deleteSingleItem(item);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      onPop?.call();
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Hapus Barang"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    );
  }
}

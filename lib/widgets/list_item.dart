import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_test_siscom/data/local/entity/item.dart';

import '../ui/list_stock/controllers/list_stock_controller.dart';
import '../utils/currency_utils.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.item,
    required this.onClick,
    required this.controller,
  });

  final Item item;
  final VoidCallback onClick;
  final ListStockController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.isEditMode.value)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Checkbox(
                  value: controller.isSelected(item.id),
                  onChanged: (_) => onClick(),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.stock} Stok',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    ));
  }
}
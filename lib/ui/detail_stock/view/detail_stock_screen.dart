import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_test_siscom/utils/currency_input_formatter.dart';
import 'package:mobile_test_siscom/utils/currency_utils.dart';

import '../../../data/local/entity/item.dart';
import '../controllers/detail_stock_controller.dart';
import '../model/detail_stock_args.dart';

class DetailStockScreen extends StatefulWidget {
  const DetailStockScreen({super.key});

  @override
  State<DetailStockScreen> createState() => _DetailStockScreenState();
}

class _DetailStockScreenState extends State<DetailStockScreen> {
  final DetailStockController controller = Get.find<DetailStockController>();

  DetailStockArgs? _args;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Worker? _itemWorker;

  final RxBool _hasErrors = false.obs;
  final RxString _nameError = ''.obs;
  final RxString _categoryError = ''.obs;
  final RxString _kelompokError = ''.obs;
  final RxString _stockError = ''.obs;
  final RxString _priceError = ''.obs;

  @override
  void initState() {
    super.initState();
    controller.fetchCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    _args = state.extra as DetailStockArgs?;
    final id = _args?.id;

    _itemWorker?.dispose();

    controller.clear();
    if (id != null) {
      controller.fetchItemById(id);
      _itemWorker = ever(controller.currentItem, (item) {
        if (item != null) {
          nameController.text = item.itemName;
          stockController.text = item.stock.toString();
          priceController.text = CurrencyUtils.formatToIdr(item.price);
          controller.selectedKategoriId.value = item.categoryId;
          controller.selectedKelompok.value = item.itemGroup;
        }
      });
    }
  }

  @override
  void dispose() {
    _itemWorker?.dispose();
    nameController.dispose();
    stockController.dispose();
    priceController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      _nameError.value = 'Nama barang harus diisi';
      isValid = false;
    } else {
      _nameError.value = '';
    }

    if (controller.selectedKategoriId.value == 0) {
      _categoryError.value = 'Kategori harus dipilih';
      isValid = false;
    } else {
      _categoryError.value = '';
    }

    if (controller.selectedKelompok.value == '') {
      _kelompokError.value = 'Kelompok barang harus dipilih';
      isValid = false;
    } else {
      _kelompokError.value = '';
    }

    if (stockController.text.isEmpty) {
      _stockError.value = 'Stok harus diisi';
      isValid = false;
    } else if (int.tryParse(stockController.text) == null) {
      _stockError.value = 'Stok harus berupa angka';
      isValid = false;
    } else {
      _stockError.value = '';
    }

    if (priceController.text.isEmpty) {
      _priceError.value = 'Harga harus diisi';
      isValid = false;
    } else {
      final cleanPrice =
          priceController.text.replaceAll(RegExp(r'[Rp.,\s]'), '');
      if (int.tryParse(cleanPrice) == null) {
        _priceError.value = 'Harga harus berupa angka';
        isValid = false;
      } else {
        _priceError.value = '';
      }
    }

    _hasErrors.value = !isValid;
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final id = _args?.id;
    final onPop = _args?.onPop;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) async {
        if (didPop) return;
        context.pop();
        onPop?.call();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(id == null ? "Tambah Barang" : "Detail Barang"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
              onPop?.call();
            },
          ),
        ),
        body: GetX<DetailStockController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Barang*",
                      errorText:
                          _nameError.value.isEmpty ? null : _nameError.value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: controller.itemCategoryList.isEmpty
                        ? null
                        : controller.selectedKategoriId.value,
                    items: controller.itemCategoryList
                        .map((cat) => DropdownMenuItem<int>(
                              value: cat.id,
                              child: Text(cat.name),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedKategoriId.value = val;
                      }
                      _categoryError.value = '';
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Barang*",
                      errorText: _categoryError.value.isEmpty
                          ? null
                          : _categoryError.value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: controller.selectedKelompok.value == ''
                        ? null
                        : controller.selectedKelompok.value,
                    items: controller.kelompokList
                        .map((g) => DropdownMenuItem<String>(
                              value: g,
                              child: Text(g),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.setKelompok(val);
                      }
                      _kelompokError.value = '';
                    },
                    decoration: InputDecoration(
                      labelText: "Kelompok Barang*",
                      errorText: _kelompokError.value.isEmpty
                          ? null
                          : _kelompokError.value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Stok*",
                      errorText:
                          _stockError.value.isEmpty ? null : _stockError.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: InputDecoration(
                      labelText: "Harga*",
                      errorText:
                          _priceError.value.isEmpty ? null : _priceError.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (!_validateFields()) {
                          return;
                        }
                        final cleanPrice = priceController.text
                            .replaceAll(RegExp(r'[Rp.,\s]'), '');
                        final item = Item(
                          id: id ?? 0,
                          itemName: nameController.text,
                          categoryId: controller.selectedKategoriId.value,
                          stock: int.tryParse(stockController.text) ?? 0,
                          itemGroup: controller.selectedKelompok.value,
                          price: int.tryParse(cleanPrice) ?? 0,
                        );

                        if (id == null) {
                          controller.createItem(item, () {
                            context.pop();
                            onPop?.call();
                          });
                        } else {
                          controller.updateItem(item, () {
                            context.pop();
                            onPop?.call();
                          });
                        }
                      },
                      child:
                          Text(id == null ? "Tambah Barang" : "Update Barang"),
                    ),
                  ),
                  if (_hasErrors.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Harap lengkapi semua field yang wajib diisi',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

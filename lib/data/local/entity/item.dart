import 'package:floor/floor.dart';

@Entity(tableName: 'item')
class Item{
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String itemName;
  final int categoryId;
  final int stock;
  final String itemGroup;
  final int price;

  Item({
    required this.id,
    required this.itemName,
    required this.categoryId,
    required this.stock,
    required this.itemGroup,
    required this.price,
  });
}
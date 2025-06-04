import 'package:floor/floor.dart';

@Entity(tableName: 'item_category')
class ItemCategory {
  @primaryKey
  final int id;
  final String name;

  ItemCategory({
    required this.id,
    required this.name
  });

}
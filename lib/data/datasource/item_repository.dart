import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prelovedrelux/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:prelovedrelux/data/model/item/item_model.dart';

abstract class ItemRepository {
  Query<Map<String, dynamic>> getListItem(String? query);

  Future<ItemModel> getDetailItem(String id);

  Future<String> uploadImage(File file, String fileName);

  Future<bool> postItem(ItemModel item);

  Future<bool> deleteItem(String itemId);

  Future<bool> buyItem(String itemId, int quantity);

  Future<bool> addItemToCart(ItemModel item);

  Future<bool> updateItemQuantity(
      String item, String itemIdFirebase, int newQTY);

  Future<bool> deleteItemFromCart(String itemId);

  Future<List<ItemModel>> getListItemFromCart();

  Future<bool> buyItemFromCart(String itemId, int quantity);
}

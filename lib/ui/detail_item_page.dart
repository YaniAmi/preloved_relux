import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prelovedrelux/bloc/detail_item_bloc/detail_item_bloc.dart';
import 'package:prelovedrelux/data/model/item/item_model.dart';

import 'checkout_page.dart';

class DetailItemPage extends StatefulWidget {
  final String idItem;

  const DetailItemPage({super.key, required this.idItem});

  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailItemBloc>().add(GetDetailItem(itemId: widget.idItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<DetailItemBloc, DetailItemState>(
        listener: (context, state) {
          if (state == const DetailItemState.empty()) {
            const Text("No Data");
          }
          if (state is AddItemToCartFailure) {
            showOkAlertDialog(
                context: context,
                title: "Error",
                message: 'This item is already in your cart!');
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is AddItemToCartSuccess) {
            showOkAlertDialog(
                context: context,
                title: "Success",
                message:
                    "Nailed it! ${state.item?.name} is chilling in your cart.");
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is BuyItemSuccess) {
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          } else if (state is BuyItemFailure) {
            context
                .read<DetailItemBloc>()
                .add(GetDetailItem(itemId: widget.idItem));
          }
        },
        child: BlocBuilder<DetailItemBloc, DetailItemState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                imageUrl: state.item?.image ?? "",
                              ),
                              Text(state.item?.name ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                              Text('Rp.${state.item?.price.toString() ?? ""}'),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Category",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(state.item?.category ?? ""),
                              const SizedBox(height: 10),
                              const Text("Description",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(state.item?.description ?? ""),
                              const SizedBox(height: 10),
                              const Text("Stock",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(state.item?.quantity.toString() ?? "")
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.item?.sellerName ?? ""),
                              Text(state.item?.sellerAddress ?? ""),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            context
                                .read<DetailItemBloc>()
                                .add(AddItemToCart(item: state.item!));
                          });
                        },
                        icon: const Icon(Icons.trolley),
                        label: const Text("Add to cart"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CheckoutPage(
                                  item: state.item ?? ItemModel.empty);
                            }));
                          },
                          child: const Text("Buy Now"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

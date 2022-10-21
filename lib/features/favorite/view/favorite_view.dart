import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:linda_wedding_ecommerce/features/favorite/cubit/favorite_cubit.dart';

import '../../../core/constants/app/colors_constants.dart';
import '../../product/blocs/products/products_bloc.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: context.paddingMedium,
                child: Column(
                  children: [
                    const Center(
                      child: Text("Favorites",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    Padding(padding: context.paddingLow),
                    BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (context, state) {
                      if (state is ProductsLoaded) {
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: FavoriteCubit().state.favList.length,
                            itemBuilder: (context, index) => Dismissible(
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.6,
                              },
                              confirmDismiss: (direction) async =>
                                  await _showDialogWidget(context),
                              movementDuration: context.durationNormal,
                              direction: DismissDirection.endToStart,
                              background: _slideRightBackground(),
                              //secondaryBackground: _slideLeftBackground(),
                              key: UniqueKey(),
                              child: Card(
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: context.width * .24,
                                        height: context.height / 8,
                                        child: CachedNetworkImage(
                                          imageUrl: state
                                              .products[FavoriteCubit()
                                                  .state
                                                  .favList[index]]!
                                              .image!,
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                  SizedBox(
                                    width: context.width * .6,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              state.products[index]!.title!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                        ),
                                        context.emptySizedHeightBoxLow,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${state.products[index]!.price} ₺",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorConstants
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })
                  ],
                ))));
  }

  Future<bool?> _showDialogWidget(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
                onPressed: () => context.router.pop(true),
                child: const Text("Delete")),
            TextButton(
              onPressed: () => context.router.pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Container _slideRightBackground() {
    return Container(
      color: ColorConstants.myRed,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: ColorConstants.myWhite,
            ),
            context.emptySizedWidthBoxNormal
          ],
        ),
      ),
    );
  }
}

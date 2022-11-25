import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:linda_wedding_ecommerce/core/extansions/string_extansion.dart';
import 'package:linda_wedding_ecommerce/core/init/lang/locale_keys.g.dart';
import 'package:linda_wedding_ecommerce/features/error/view/error_view.dart';
import 'package:linda_wedding_ecommerce/features/product/model/products_model.dart';

import '../../../core/components/indicator/loading_indicator.dart';
import '../../../core/constants/app/colors_constants.dart';
import '../../../core/init/network/service/network_service.dart';
import '../../../core/init/routes/routes.gr.dart';
import '../../../product/widgets/ebutton_widget.dart';
import '../../../product/widgets/iconbutton_widget.dart';
import '../../../product/widgets/textfield_widget.dart';
import '../../product/blocs/products/products_bloc.dart';
import '../model/cart_model.dart';
import '../../../product/widgets/empty_info_widget.dart';

class CartView extends StatefulWidget {
  final CartModel? cartModel;
  const CartView({super.key, this.cartModel});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final manager = NetworkService.instance.networkManager;

  @override
  void initState() {
    // final authBloc = BlocProvider.of<AuthBloc>(context);
    // BlocProvider.of<CartBloc>(context)
    //     .add(FetchCarts(manager, scaffoldKey, authBloc));
    super.initState();
  }

  ValueNotifier<List<int>> quantityList = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: (widget.cartModel == null)
            ? EmptyInfoWidget(
                lottieSrc: "empty_cart",
                text: LocaleKeys.cart_emptyTitle.locale)
            : _buildCartLoaded(widget.cartModel!));
  }

  Widget _buildCartLoaded(CartModel cartModel) =>
      BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
        return state.maybeWhen(
            loading: () =>
                const LoadingIndicatorWidget(lottieName: "cart_loading"),
            loaded: (products, productsByCat, isFilterCat) =>
                _buildProdLoaded(context, cartModel, products),
            error: (error) =>
                Center(child: ErrorView(errorText: error.toString())),
            orElse: () => EmptyInfoWidget(
                lottieSrc: "empty_cart",
                text: LocaleKeys.cart_emptyTitle.locale));
      });

  _buildProdLoaded(BuildContext context, CartModel cartModel,
      List<ProductsModel?> products) {
    double total = 0;
    //*Total Cart Price
    for (var e in cartModel.products) {
      quantityList.value.add(e.quantity);
      total += e.quantity * products[e.productId - 1]!.price!;
    }
    void quantityChangeNotifier(int index) {
      List<int> newQList = List.from(quantityList.value);
      quantityList.value = newQList;
    }

    return ValueListenableBuilder(
        valueListenable: quantityList,
        builder: (context, value, child) => quantityList.value.isEmpty
            ? EmptyInfoWidget(
                lottieSrc: "empty_cart",
                text: LocaleKeys.cart_emptyTitle.locale)
            : Scaffold(
                body: SingleChildScrollView(
                  primary: true,
                  child: Padding(
                    padding: context.paddingMedium,
                    child: Center(
                      child: Column(
                        children: [
                          Text(LocaleKeys.cart_topTitle.locale,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Padding(padding: context.paddingLow),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartModel.products.length,
                            itemBuilder: (context, index) => Dismissible(
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.6
                              },
                              confirmDismiss: (direction) async =>
                                  await _showDialogWidget(context, index),
                              movementDuration: context.durationNormal,
                              direction: DismissDirection.endToStart,
                              background: _slideRightBackground(),
                              //secondaryBackground: _slideLeftBackground(),
                              key: UniqueKey(),
                              child: GestureDetector(
                                onTap: () =>
                                    context.router.push(ProductDetailView(
                                  id: cartModel.products[index].productId,
                                  manager:
                                      NetworkService.instance.networkManager,
                                )),
                                child: Card(
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          width: context.width * .24,
                                          height: context.height / 8,
                                          child: CachedNetworkImage(
                                            imageUrl: products[cartModel
                                                        .products[index]
                                                        .productId -
                                                    1]!
                                                .image!,
                                            fit: BoxFit.contain,
                                          )),
                                    ),
                                    SizedBox(
                                      width: context.width * .53,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                products[cartModel
                                                            .products[index]
                                                            .productId -
                                                        1]!
                                                    .title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall),
                                          ),
                                          context.emptySizedHeightBoxLow,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${products[cartModel.products[index].productId - 1]!.price} ₺",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Row(
                                                children: [
                                                  IconButtonWidget(
                                                      onPress: () {
                                                        quantityChangeNotifier(
                                                            index);
                                                        quantityList.value[
                                                                    index] ==
                                                                1
                                                            ? null
                                                            : quantityList
                                                                    .value[
                                                                index] -= 1;
                                                        quantityChangeNotifier(
                                                            index);
                                                      },
                                                      circleRadius: 14,
                                                      size: 12,
                                                      icon: Icons.remove,
                                                      iColor: ColorConstants
                                                          .myBlack,
                                                      tooltip: "Remove"),
                                                  Text(
                                                    cartModel.products[index]
                                                        .quantity
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  IconButtonWidget(
                                                      onPress: () =>
                                                          quantityList.value[
                                                              index] += 1,
                                                      circleRadius: 14,
                                                      size: 12,
                                                      icon: Icons.add,
                                                      iColor: ColorConstants
                                                          .myBlack,
                                                      tooltip: "Add")
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            color: ColorConstants.myWhite,
                            padding: context.paddingHigh,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(LocaleKeys.cart_subTotal.locale),
                                    const Expanded(child: Divider()),
                                    Text(
                                        "${(total * .82).toStringAsFixed(2)} ₺",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(LocaleKeys.cart_tax.locale),
                                    const Expanded(child: Divider()),
                                    Text(
                                        "${(total * .18).toStringAsFixed(2)} ₺",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          TextFieldWidget(
                              hintText: LocaleKeys.cart_discCode.locale,
                              sIcon: Icons.check_circle_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
                persistentFooterAlignment: AlignmentDirectional.center,
                persistentFooterButtons: [_buildBottomWidget(context, total)]));
  }

  Future<bool?> _showDialogWidget(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.cart_alert_title.locale),
          content: Text(LocaleKeys.cart_alert_content.locale),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  context.router.pop(true);
                  quantityList.value.removeAt(index);
                },
                child: Text(LocaleKeys.cart_alert_buttonText.locale)),
            TextButton(
              onPressed: () => context.router.pop(false),
              child: Text(LocaleKeys.cart_alert_button2Text.locale),
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

  Padding _buildBottomWidget(BuildContext context, double total) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * .02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.cart_price.locale,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "${total.toStringAsFixed(2)} ₺",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            EButtonWidget(
                text: LocaleKeys.cart_buttonText.locale,
                width: 150,
                onPress: () => context.router.push(const Checkout()))
          ],
        ));
  }
}

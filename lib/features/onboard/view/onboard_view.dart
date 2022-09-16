import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linda_wedding_ecommerce/core/routes/routes.gr.dart';
import '../../product/blocs/categories/categories_bloc.dart';

import '../../product/blocs/products/products_bloc.dart';
import '../../product/model/products_model.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  @override
  void initState() {
    BlocProvider.of<CategoriesBloc>(context).add((CategoriesFetched()));
    BlocProvider.of<ProductsBloc>(context).add((ProductsFetched()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LindaWedding - Home"),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<CategoriesBloc, CategoriesState>(
                listener: (context, state) {
              if (state is CategoriesError) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: state.error == "XMLHttpRequest error."
                      ? const Text("Hata-> (İstekte bulunulan adres hatalı.)")
                      : const Text("Hata-> (Connection timeout)"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }, builder: (context, state) {
              if (state is CategoriesInitial) {
                return _buildLoadingWidget();
              } else if (state is CategoriesLoading) {
                return _buildLoadingWidget();
              } else if (state is CategoriesLoaded) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => BlocProvider.of<ProductsBloc>(context).add(
                          ProductsByCategoryFetched(state.categories[index])),
                      child: Container(
                          margin: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //*Kontrol edilecek
                              color: state.categories
                                          .indexOf(state.categories[index]) ==
                                      index
                                  ? Colors.redAccent
                                  : Color(Random().nextInt(0xfff0f0f0))),
                          child: Center(child: Text(state.categories[index]))),
                    );
                  },
                );
              } else {
                return Container();
              }
            }),
          ),
          Expanded(
            flex: 5,
            child: BlocConsumer<ProductsBloc, ProductsState>(
                listener: (context, state) {
              if (state is ProductsError) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: state.error == "XMLHttpRequest error."
                      ? const Text("Hata-> (İstekte bulunulan adres hatalı.)")
                      : const Text("Hata-> (Bağlantı zaman aşımı..)"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }, builder: (context, state) {
              if (state is ProductsInitial) {
                return _buildLoadingWidget();
              } else if (state is ProductsLoading) {
                return _buildLoadingWidget();
              } else if (state is ProductsLoaded) {
                return _buildBodyWidget(context, state.products);
              } else {
                return Container();
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(label: "", icon: Icon(Icons.home_rounded)),
        BottomNavigationBarItem(label: "", icon: Icon(Icons.home_rounded)),
      ]),
    );
  }

  Center _buildLoadingWidget() =>
      const Center(child: CircularProgressIndicator());
}

Widget _buildBodyWidget(BuildContext context, List<ProductsModel?> model) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 280,
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5),
    shrinkWrap: true,
    itemCount: model.length,
    itemBuilder: ((context, index) {
      final rating = model[index]!.rating.rate.round();
      return GestureDetector(
        onTap: () =>
            context.router.push(ProductDetailView(id: model[index]!.id)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 5,
                blurRadius: 1,
                offset: const Offset(0, 0.2), // changes position of shadow
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Image.network(model[index]!.image,
                    fit: BoxFit.contain, height: 180),
                Text(model[index]!.title, overflow: TextOverflow.ellipsis),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 5; i++)
                      Icon(
                        rating > i ? Icons.star : Icons.star_border_outlined,
                        color: Colors.amber,
                        size: 14,
                      ),
                    Text(" ( ${model[index]!.rating.count} )",
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${model[index]!.price} TL",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

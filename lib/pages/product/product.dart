import 'package:dundermifflinapp/components/header.dart';
import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';
import 'package:dundermifflinapp/pages/help/help.dart';
import 'package:flutter/material.dart';
import 'package:dundermifflinapp/components/bottom_navigation.dart';
import 'package:dundermifflinapp/components/product_filter.dart';
import 'package:dundermifflinapp/components/skeleton_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dundermifflinapp/api/getProduct_bloc.dart';
import 'dart:convert';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 1;
  String _searchQuery = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Produtos'),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Column(
        children: [
          ProductFilter(onSearch: _onSearch),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const SkeletonLoader();
                } else if (state is ProductLoaded) {
                  final filteredProducts = state.products.where((product) {
                    final productName = product['name'] as String? ?? '';
                    final categoryName =
                        product['categoriaNome'] as String? ?? '';
                    final subCategoryName =
                        product['subcategoriaNome'] as String? ?? '';
                    final query = _searchQuery.toLowerCase();
                    return productName.toLowerCase().contains(query) ||
                        categoryName.toLowerCase().contains(query) ||
                        subCategoryName.toLowerCase().contains(query);
                  }).toList();

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final imageUrl =
                                product['file']['imagem'] as String? ?? '';
                            final productName =
                                product['nome'] as String? ?? 'Nome do Produto';
                            final categoryName =
                                product['categoriaNome'] as String? ??
                                    'Descrição do Produto';
                            final subCategoryName =
                                product['subcategoriaNome'] as String? ??
                                    'Subcategoria do Produto';
                            final productPrice =
                                product['precoAtual'] as double? ?? 0.0;

                            return Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (imageUrl.isNotEmpty)
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Image.memory(
                                            base64Decode(imageUrl),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    const Expanded(
                                      child: Placeholder(),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Wrap(
                                      spacing: 2.0,
                                      children: [
                                        Chip(
                                          label: Text(
                                            categoryName,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          backgroundColor:
                                              const Color(0xFFABABAF),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.zero,
                                        ),
                                        Chip(
                                          label: Text(
                                            subCategoryName,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          backgroundColor:
                                              const Color(0xFFABABAF),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(),
                                        Text(
                                          'R\$${productPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: AppColors.primaryBase,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBase,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Nova Solicitação de Atendimento',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is ProductFailure) {
                  return Center(child: Text('Erro: ${state.error}'));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

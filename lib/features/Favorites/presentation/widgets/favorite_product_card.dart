import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/features/favorites/presentation/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:laza/features/favorites/presentation/cubits/favorites_cubit/favorites_state.dart';
import 'package:laza/features/home/data/models/product_model.dart';

class FavoriteProductCard extends StatelessWidget {
  final ProductModel product;

  const FavoriteProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    log('❤️ [FavoriteProductCard] Building card for product ${product.id}');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.coverPictureUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Enable caching for better performance
                  cacheWidth: 300, // Optimize memory usage
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/image.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              // Favorite Button with Material wrapper for better touch feedback
              Positioned(
                top: 8,
                right: 8,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    log(
                      '❤️ [FavoriteProductCard] BlocBuilder state update for ${product.id}: ${state.runtimeType}',
                    );

                    // This should always be true since we're in favorites screen
                    final isFavorite = state is FavoritesLoaded;

                    log(
                      '❤️ [FavoriteProductCard] Product ${product.id} isFavorite: $isFavorite',
                    );

                    return Material(
                      color: Colors.white.withOpacity(0.8),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          log(
                            '❤️ [FavoriteProductCard] Remove from favorites button pressed for ${product.id}',
                          );
                          final favCubit = getIt<FavoritesCubit>();
                          log(
                            '❤️ [FavoriteProductCard] Using FavoritesCubit instance: ${favCubit.hashCode}',
                          );
                          favCubit.toggleFavorite(product);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

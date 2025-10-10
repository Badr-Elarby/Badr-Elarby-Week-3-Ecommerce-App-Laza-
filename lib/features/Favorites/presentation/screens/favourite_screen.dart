import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/favorites/presentation/widgets/favorite_product_card.dart';
import 'package:laza/features/favorites/presentation/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:laza/features/favorites/presentation/cubits/favorites_cubit/favorites_state.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    log('🏠 [FavoriteScreen] initState called');
    final cubit = context.read<FavoritesCubit>();
    log('🏠 [FavoriteScreen] Got FavoritesCubit instance: ${cubit.hashCode}');
    cubit.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    log('🏠 [FavoriteScreen] Building screen');
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          log(
            '🏠 [FavoriteScreen] BlocBuilder rebuilding with state: ${state.runtimeType}',
          );
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(child: Text(state.message));
          }

          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(
                child: Text('No favorites yet', style: TextStyle(fontSize: 16)),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final product = state.favorites[index];
                return FavoriteProductCard(product: product);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

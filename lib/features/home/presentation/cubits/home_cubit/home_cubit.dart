import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/features/home/data/models/product_model.dart';
import 'package:laza/features/home/data/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';
  static const int _defaultPageSize = 20; // Number of products per page

  HomeCubit(this._homeRepository, this._prefs) : super(HomeInitial());

  /// Loads the first page of products (initial load)
  Future<void> getProducts({int? page, int? pageSize}) async {
    print('HomeCubit: Loading products (page: ${page ?? 1})...');
    emit(HomeLoading());
    try {
      final response = await _homeRepository.getProducts(
        page: page ?? 1,
        pageSize: pageSize ?? _defaultPageSize,
      );

      // Update products with favorite status
      final products = response.items.map((product) {
        final isFavorite = _isFavorite(product.id);
        return product.copyWith(isLiked: isFavorite);
      }).toList();

      print('HomeCubit: Loaded ${products.length} products successfully');
      emit(HomeSuccess(
        products: products,
        hasMorePages: response.hasNextPage,
        currentPage: response.page,
      ));
    } catch (e) {
      print('HomeCubit: Error loading products: $e');
      emit(HomeError(e.toString()));
    }
  }

  /// Loads the next page of products and appends to existing list (pagination)
  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    // Prevent duplicate requests
    if (currentState.isLoadingMore || !currentState.hasMorePages) {
      return;
    }

    final nextPage = currentState.currentPage + 1;
    print('HomeCubit: Loading next page ($nextPage)...');

    // Emit loading more state
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final response = await _homeRepository.getProducts(
        page: nextPage,
        pageSize: _defaultPageSize,
      );

      // Update new products with favorite status
      final newProducts = response.items.map((product) {
        final isFavorite = _isFavorite(product.id);
        return product.copyWith(isLiked: isFavorite);
      }).toList();

      // Append new products to existing list
      final allProducts = [...currentState.products, ...newProducts];

      print('HomeCubit: Loaded ${newProducts.length} more products (total: ${allProducts.length})');
      emit(HomeSuccess(
        products: allProducts,
        hasMorePages: response.hasNextPage,
        isLoadingMore: false,
        currentPage: nextPage,
      ));
    } catch (e) {
      print('HomeCubit: Error loading next page: $e');
      // Revert to previous state on error
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (state is HomeSuccess) {
      try {
        final currentState = state as HomeSuccess;
        final isFavorite = _isFavorite(product.id);

        // Toggle in local storage
        List<ProductModel> favorites = _getFavorites();
        if (isFavorite) {
          favorites.removeWhere((p) => p.id == product.id);
        } else {
          favorites.add(product);
        }
        await _saveFavorites(favorites);

        // Update the product's favorite status in the current list
        final updatedProducts = currentState.products.map((p) {
          if (p.id == product.id) {
            return p.copyWith(isLiked: !isFavorite);
          }
          return p;
        }).toList();

        // Emit updated state with pagination info preserved
        emit(currentState.copyWith(products: updatedProducts));
        print(
          'HomeCubit: Toggled favorite for product ${product.id} (isFavorite: ${!isFavorite})',
        );
      } catch (e) {
        print('HomeCubit: Error toggling favorite: $e');
        emit(HomeError('Failed to toggle favorite: $e'));
      }
    }
  }

  bool _isFavorite(String productId) {
    final favorites = _getFavorites();
    return favorites.any((product) => product.id == productId);
  }

  List<ProductModel> _getFavorites() {
    final favoritesList = _prefs.getStringList(_favoritesKey) ?? [];
    return favoritesList
        .map((json) => ProductModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveFavorites(List<ProductModel> favorites) async {
    final List<String> jsonList = favorites
        .map((product) => jsonEncode(product.toJson()))
        .toList();
    await _prefs.setStringList(_favoritesKey, jsonList);
  }
}

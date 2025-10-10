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

  HomeCubit(this._homeRepository, this._prefs) : super(HomeInitial());

  Future<void> getProducts({int? page, int? pageSize}) async {
    print('HomeCubit: Loading products...');
    emit(HomeLoading());
    try {
      final response = await _homeRepository.getProducts(
        page: page,
        pageSize: pageSize,
      );

      // Update products with favorite status
      final products = response.items.map((product) {
        final isFavorite = _isFavorite(product.id);
        return product.copyWith(isLiked: isFavorite);
      }).toList();

      print('HomeCubit: Loaded ${products.length} products successfully');
      emit(HomeSuccess(products));
    } catch (e) {
      print('HomeCubit: Error loading products: $e');
      emit(HomeError(e.toString()));
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

        // Emit updated state to reflect changes in UI immediately
        emit(HomeSuccess(updatedProducts));
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

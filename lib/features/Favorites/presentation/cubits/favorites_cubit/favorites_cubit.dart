import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/features/home/data/models/product_model.dart';
import 'package:laza/features/favorites/presentation/cubits/favorites_cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  FavoritesCubit(this._prefs) : super(FavoritesInitial()) {
    log(
      '⭐ [FavoritesCubit] Created new instance with hashCode: ${identityHashCode(this)}',
    );
  }

  @override
  void onChange(Change<FavoritesState> change) {
    super.onChange(change);
    log(
      '⭐ [FavoritesCubit] State changed from ${change.currentState.runtimeType} to ${change.nextState.runtimeType}',
    );
  }

  Future<void> loadFavorites() async {
    try {
      log('⭐ [FavoritesCubit] Loading favorites...');
      emit(FavoritesLoading());

      final favorites = _getFavorites();
      log(
        '⭐ [FavoritesCubit] Loaded ${favorites.length} favorites from storage',
      );

      // Ensure all loaded favorites have isLiked set to true
      final updatedFavorites = favorites
          .map((product) => product.copyWith(isLiked: true))
          .toList();
      log('⭐ [FavoritesCubit] Updated isLiked flag for all favorites');

      log(
        '⭐ [FavoritesCubit] Emitting FavoritesLoaded with ${updatedFavorites.length} items',
      );
      emit(FavoritesLoaded(updatedFavorites));

      if (updatedFavorites.isNotEmpty) {
        log(
          '📝 [FavoritesCubit] First favorite item: ${updatedFavorites.first.toJson()}',
        );
      }
    } catch (e) {
      log('❌ [FavoritesCubit] Error loading favorites: $e');
      emit(FavoritesError('Failed to load favorites: $e'));
    }
  }

  List<ProductModel> _getFavorites() {
    final favoritesList = _prefs.getStringList(_favoritesKey) ?? [];
    return favoritesList
        .map((json) => ProductModel.fromJson(jsonDecode(json)))
        .toList();
  }

  bool isFavorite(String productId) {
    final favorites = _getFavorites();
    return favorites.any((product) => product.id == productId);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    try {
      log('⭐ [FavoritesCubit] toggleFavorite called for: ${product.id}');
      log(
        '⭐ [FavoritesCubit] Cubit instance hashCode: ${identityHashCode(this)}',
      );
      log('⭐ [FavoritesCubit] Current state type: ${state.runtimeType}');

      final rawPrefs = _prefs.getStringList(_favoritesKey);
      log('⭐ [FavoritesCubit] Raw SharedPrefs before toggle: $rawPrefs');

      // Get current state favorites if available, otherwise fetch from storage
      List<ProductModel> currentFavorites = [];
      if (state is FavoritesLoaded) {
        currentFavorites = (state as FavoritesLoaded).favorites.toList();
        log(
          '⭐ [FavoritesCubit] Using favorites from state: ${currentFavorites.length} items',
        );
      } else {
        currentFavorites = _getFavorites();
        log(
          '⭐ [FavoritesCubit] Loaded favorites from storage: ${currentFavorites.length} items',
        );
      }

      final isFavorite = currentFavorites.any((p) => p.id == product.id);
      List<ProductModel> updatedFavorites;

      if (isFavorite) {
        // Remove from favorites
        updatedFavorites = currentFavorites
            .where((p) => p.id != product.id)
            .toList();
        log('⭐ [FavoritesCubit] Removed product ${product.id} from favorites');
      } else {
        // Add to favorites with isLiked set to true
        final productWithLike = product.copyWith(isLiked: true);
        log(
          '⭐ [FavoritesCubit] Adding product with isLiked=true: ${productWithLike.isLiked}',
        );
        updatedFavorites = [...currentFavorites, productWithLike];
        log('⭐ [FavoritesCubit] Added product ${product.id} to favorites');
      }

      // Emit new state immediately for UI update
      log(
        '⭐ [FavoritesCubit] Emitting new state with ${updatedFavorites.length} favorites',
      );
      emit(FavoritesLoaded(updatedFavorites));

      // Save to SharedPreferences
      log('⭐ [FavoritesCubit] Saving to SharedPreferences...');
      await _saveFavorites(updatedFavorites);

      // Verify save was successful
      final savedList = _prefs.getStringList(_favoritesKey);
      log(
        '⭐ [FavoritesCubit] Verification - Raw SharedPrefs after save: $savedList',
      );

      if (savedList == null) {
        log(
          '❌ [FavoritesCubit] ERROR: Save verification failed - prefs returned null',
        );
      } else {
        log(
          '✅ [FavoritesCubit] Save verified - ${savedList.length} items in storage',
        );
      }
    } catch (e) {
      log('❌ [FavoritesCubit] Error in toggleFavorite: $e');
      emit(FavoritesError('Failed to toggle favorite: $e'));
    }
  }

  Future<void> _saveFavorites(List<ProductModel> favorites) async {
    try {
      log('⭐ [FavoritesCubit] Preparing to save ${favorites.length} favorites');
      final List<String> jsonList = favorites
          .map((product) => jsonEncode(product.toJson()))
          .toList();
      final result = await _prefs.setStringList(_favoritesKey, jsonList);
      log('⭐ [FavoritesCubit] Save result: $result');
    } catch (e) {
      log('❌ [FavoritesCubit] Error in _saveFavorites: $e');
      rethrow;
    }
  }
}

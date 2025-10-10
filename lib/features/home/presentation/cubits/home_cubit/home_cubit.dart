import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laza/features/home/data/models/product_model.dart';
import 'package:laza/features/home/data/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitial());

  Future<void> getProducts({int? page, int? pageSize}) async {
    print('HomeCubit: Loading products...');
    emit(HomeLoading());
    try {
      final response = await _homeRepository.getProducts(
        page: page,
        pageSize: pageSize,
      );
      print('HomeCubit: Loaded ${response.items.length} products successfully');
      emit(HomeSuccess(response.items));
    } catch (e) {
      print('HomeCubit: Error loading products: $e');
      emit(HomeError(e.toString()));
    }
  }
}

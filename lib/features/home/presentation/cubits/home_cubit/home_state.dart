part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<ProductModel> products;
  final bool hasMorePages;
  final bool isLoadingMore;
  final int currentPage;

  const HomeSuccess({
    required this.products,
    this.hasMorePages = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });

  HomeSuccess copyWith({
    List<ProductModel>? products,
    bool? hasMorePages,
    bool? isLoadingMore,
    int? currentPage,
  }) {
    return HomeSuccess(
      products: products ?? this.products,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [products, hasMorePages, isLoadingMore, currentPage];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

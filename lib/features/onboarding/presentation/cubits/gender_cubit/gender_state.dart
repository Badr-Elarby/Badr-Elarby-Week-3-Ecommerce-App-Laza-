part of 'gender_cubit.dart';

abstract class GenderState {}

class GenderInitial extends GenderState {}

class GenderLoading extends GenderState {}

class GenderSuccess extends GenderState {
  final String selectedGender;

  GenderSuccess(this.selectedGender);
}

class GenderError extends GenderState {
  final String message;

  GenderError(this.message);
}

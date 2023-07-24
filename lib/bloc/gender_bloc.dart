import 'package:flutter_bloc/flutter_bloc.dart';

enum GenderType { woman, man, withoutAnswer }

abstract class GenderScreenEvent {}

class GenderInitialEvent extends GenderScreenEvent {}

class GenderSelectEvent extends GenderScreenEvent {
  final GenderType gender;

  GenderSelectEvent(this.gender);
}

abstract class GenderScreenState {}

class GenderInitialState extends GenderScreenState {}

class GenderSelectedState extends GenderScreenState {}

class GenderScreenBloc extends Bloc<GenderScreenEvent, GenderScreenState> {
  GenderType? selectedGender;

  GenderScreenBloc() : super(GenderInitialState()) {
    on<GenderSelectEvent>((event, emit) {
      selectedGender = event.gender;
      emit(GenderSelectedState());
    });

    on<GenderInitialEvent>((event, emit) {
      selectedGender = null;
      emit(GenderInitialState());
    });
  }
}

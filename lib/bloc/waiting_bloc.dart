import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genthis_test_task/repository/images_repository.dart';

abstract class WaitingScreenEvent {}

class InitializeEvent extends WaitingScreenEvent {}

class LoadImagesEvent extends WaitingScreenEvent {}

abstract class WaitingScreenState {}

class InitialState extends WaitingScreenState {}

class ImageLoadedState extends WaitingScreenState {
  final List<ImageProvider> goodImages;
  final List<ImageProvider> badImages;

  ImageLoadedState(this.goodImages, this.badImages);
}

class WaitingScreenBloc extends Bloc<WaitingScreenEvent, WaitingScreenState> {
  final ImagesRepository imagesRepository;
  List<ImageProvider> manBadImages = [];
  List<ImageProvider> manGoodImages = [];
  List<ImageProvider> womanBadImages = [];
  List<ImageProvider> womanGoodImages = [];

  WaitingScreenBloc(this.imagesRepository) : super(InitialState()) {
    on<LoadImagesEvent>((event, emit) async {
      womanGoodImages = await imagesRepository.fetchWomanGood();
      womanBadImages = await imagesRepository.fetchWomanBad();
      manGoodImages = await imagesRepository.fetchManGood();
      manBadImages = await imagesRepository.fetchManBad();

      emit(ImageLoadedState(manGoodImages, manBadImages));
    });
  }
}

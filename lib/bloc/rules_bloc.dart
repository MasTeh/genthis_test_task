import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:genthis_test_task/repository/images_api_repository.dart';
import 'package:image/image.dart';

abstract class RulesScreenEvent {}

class InitialEvent extends RulesScreenEvent {}

class PushPhotosEvent extends RulesScreenEvent {
  final List<PickedAssetModel> galleryAssetPaths;

  PushPhotosEvent(this.galleryAssetPaths);
}

class StartPhotosProccessingEvent extends RulesScreenEvent {}

abstract class RulesScreenState {}

class InitialState extends RulesScreenState {}

class PhotoUploaded extends RulesScreenState {}

class RulesScreenBloc extends Bloc<RulesScreenEvent, RulesScreenState> {
  ImagesAPIRepository imagesAPIRepository;
  List<PickedAssetModel> galleryAssetPaths = [];
  final int maxFileSize = 200 * 1024;

  Image resizeToFileSize(int needsFileSize, Image image) {
    print("recompress image ${image.hashCode}");

    if (image.data!.lengthInBytes <= needsFileSize) return image;

    double compressK = 0.8;
    double sizeDifference = image.data!.lengthInBytes / needsFileSize;

    if (sizeDifference >= 3) {
      compressK = 0.3;
    } else if (sizeDifference >= 2) {
      compressK = 0.5;
    }

    return resizeToFileSize(
        needsFileSize, copyResize(image, width: (image.data!.width * compressK).round()));
  }

  RulesScreenBloc(this.imagesAPIRepository) : super(InitialState()) {
    on<PushPhotosEvent>((event, emit) async {
      galleryAssetPaths = event.galleryAssetPaths;
    });

    on<StartPhotosProccessingEvent>((event, emit) async {
      List<String> base64Images = [];
      for (var asset in galleryAssetPaths) {
        Image? image = decodeImage(asset.file!.readAsBytesSync());
        print("Image initial size ${image!.data!.lengthInBytes}");

        Image resizedImage = resizeToFileSize(200 * 1024, image);
        String base64Image = base64Encode(resizedImage.getBytes());
        print("Image resized size ${resizedImage.data!.lengthInBytes}");
        print("Image result width ${resizedImage.data!.width}");

        base64Images.add(base64Image);
      }

      imagesAPIRepository.sendToServer(base64Images);

      emit(PhotoUploaded());
    });
  }
}

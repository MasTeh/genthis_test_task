import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:genthis_test_task/bloc/gender_bloc.dart';
import 'package:genthis_test_task/bloc/rules_bloc.dart';
import 'package:genthis_test_task/bloc/waiting_bloc.dart';
import 'package:genthis_test_task/pages/check_screen.dart';
import 'package:genthis_test_task/widgets/photos_generation.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final List<PickedAssetModel> galleryAssetPaths = [];

  bool photosFromGalleryIsChoosen = false;

  List<ImageProvider> meshOneToOne(List<ImageProvider> list1, List<ImageProvider> list2) {
    List<ImageProvider> resultList = [];
    var list2Map = list2.asMap();
    list1.asMap().forEach((key, value) {
      resultList.add(value);
      if (list2Map[key] != null) {
        resultList.add(list2Map[key]!);
      }
    });

    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rules")),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              Text(AppLocalizations.of(context).rules_explain,
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
              const Divider(height: 20),
              Builder(builder: (context) {
                var gender = context.read<GenderScreenBloc>().selectedGender;
                var manGoodImages = context.read<WaitingScreenBloc>().manGoodImages;
                var womanGoodImages = context.read<WaitingScreenBloc>().womanGoodImages;
                var manBadImages = context.read<WaitingScreenBloc>().manBadImages;
                var womanBadImages = context.read<WaitingScreenBloc>().womanBadImages;

                if (gender == GenderType.man) {
                  return Column(children: [
                    PhotosGenerationWidget(images: manGoodImages, isSuccessfull: true),
                    const Divider(height: 20),
                    PhotosGenerationWidget(images: manBadImages, isSuccessfull: false),
                  ]);
                }

                if (gender == GenderType.woman) {
                  return Column(children: [
                    PhotosGenerationWidget(images: womanGoodImages, isSuccessfull: true),
                    const Divider(height: 20),
                    PhotosGenerationWidget(images: womanBadImages, isSuccessfull: false),
                  ]);
                }

                if (gender == GenderType.withoutAnswer) {
                  return Column(children: [
                    PhotosGenerationWidget(
                        images: meshOneToOne(manGoodImages, womanGoodImages), isSuccessfull: true),
                    const Divider(height: 20),
                    PhotosGenerationWidget(
                        images: meshOneToOne(manBadImages, womanBadImages), isSuccessfull: false),
                  ]);
                }

                return const Center(child: CircularProgressIndicator());
              })
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_upload_outlined, color: Colors.white),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog.fullscreen(
                            child: GalleryMediaPicker(
                              pathList: (List<PickedAssetModel> paths) {
                                galleryAssetPaths.clear();
                                galleryAssetPaths.addAll(paths);
                              },
                              mediaPickerParams: MediaPickerParamsModel(
                                  maxPickImages: 15,
                                  singlePick: false,
                                  onlyImages: true,
                                  appBarHeight: 80,
                                  appBarLeadingWidget: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: !photosFromGalleryIsChoosen
                                            ? ElevatedButton(
                                                style: const ButtonStyle(
                                                    visualDensity: VisualDensity.compact),
                                                onPressed: () {
                                                  if (photosFromGalleryIsChoosen) return;

                                                  context
                                                      .read<RulesScreenBloc>()
                                                      .add(PushPhotosEvent(galleryAssetPaths));

                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => const CheckPage()));
                                                },
                                                child: const Text("Choose photos"))
                                            : const CircularProgressIndicator(),
                                      ))),
                            ),
                          );
                        });
                  },
                  label: const Text("Choose 10-15 photos")),
            ),
          )
        ],
      ),
    );
  }
}

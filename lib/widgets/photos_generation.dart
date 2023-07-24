import 'package:flutter/material.dart';
import 'package:genthis_test_task/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class _GenerationResultWidget extends StatelessWidget {
  final bool _isSuccessfull;
  const _GenerationResultWidget({Key? key, required bool isSuccessfull})
      : _isSuccessfull = isSuccessfull,
        super(key: key);

  final _textStyle =
      const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: _isSuccessfull ? DesignColors.positiveColor : DesignColors.negativeColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
              child: _isSuccessfull
                  ? const Icon(Icons.check, color: DesignColors.backgroundColor, size: 16)
                  : const Icon(Icons.close, color: DesignColors.backgroundColor, size: 16)),
        ),
        Container(width: 12),
        Text(
            _isSuccessfull
                ? AppLocalizations.of(context).successfull_generation_label
                : AppLocalizations.of(context).unsuccessfull_generation_label,
            style: _textStyle)
      ],
    );
  }
}

class _PhotoWidget extends StatefulWidget {
  final ImageProvider imageProvider;
  const _PhotoWidget({Key? key, required this.imageProvider}) : super(key: key);

  @override
  State<_PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<_PhotoWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image(image: widget.imageProvider, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class PhotosGenerationWidget extends StatefulWidget {
  final List<ImageProvider> images;
  final bool isSuccessfull;  
  const PhotosGenerationWidget({Key? key, required this.images, required this.isSuccessfull})
      : super(key: key);

  @override
  State<PhotosGenerationWidget> createState() => _PhotosGenerationWidgetState();
}

class _PhotosGenerationWidgetState extends State<PhotosGenerationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _GenerationResultWidget(isSuccessfull: widget.isSuccessfull),
          const Divider(),
          Builder(builder: (context) {
            List<Widget> items = [];
            for (var image in widget.images) {
              items.add(_PhotoWidget(imageProvider: image));
            }
            return SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: items,
              ),
            );
          })
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genthis_test_task/bloc/waiting_bloc.dart';
import 'package:genthis_test_task/pages/gender_selection_screen.dart';
import 'package:genthis_test_task/widgets/photos_generation.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool _ageAgree = false;

  @override
  void initState() {
    super.initState();

    context.read<WaitingScreenBloc>().add(LoadImagesEvent());
  }

  void onContinueButtonClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const GenderSelection()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Header")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(AppLocalizations.of(context).waiting_explain1, textAlign: TextAlign.center),
          const Divider(),
          Text(AppLocalizations.of(context).waiting_explain2, textAlign: TextAlign.center),
          const Divider(),
          BlocBuilder<WaitingScreenBloc, WaitingScreenState>(builder: (context, state) {
            if (state is ImageLoadedState) {
              return Column(
                children: [
                  PhotosGenerationWidget(images: state.goodImages, isSuccessfull: true),
                  PhotosGenerationWidget(images: state.badImages, isSuccessfull: false),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
          const Divider(),
          CheckboxListTile.adaptive(
              controlAffinity: ListTileControlAffinity.leading,
              value: _ageAgree,
              onChanged: (value) => setState(() {
                    _ageAgree = value ?? false;
                  }),
              title: Text(AppLocalizations.of(context).age_agree)),
          ElevatedButton(
              onPressed: _ageAgree ? () => onContinueButtonClick() : null,
              child: const Text("Continue"))
        ],
      ),
    );
  }
}

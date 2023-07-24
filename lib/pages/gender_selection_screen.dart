import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genthis_test_task/bloc/gender_bloc.dart';
import 'package:genthis_test_task/pages/rules_screen.dart';
import 'package:genthis_test_task/theme/app_theme.dart';
import 'package:genthis_test_task/widgets/custom_bubble.dart';
import 'package:genthis_test_task/widgets/select_buttons.dart';

class GenderSelection extends StatefulWidget {
  const GenderSelection({Key? key}) : super(key: key);

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  final Map<String, GenderType> _items = {
    "Man": GenderType.man,
    "Woman": GenderType.woman,
    "Without answer": GenderType.withoutAnswer
  };

  final tooltipKey = GlobalKey<TooltipState>();
  final tooltipButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<GenderScreenBloc>().add(GenderInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gender selection")),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ListView(children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(AppLocalizations.of(context).gender_page_explain,
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ),
              SelectButtons(
                items: List.from(_items.keys),
                callback: (index) {
                  String elementName = List<String>.from(_items.keys)[index];
                  context.read<GenderScreenBloc>().add(GenderSelectEvent(_items[elementName]!));
                },
              ),
              const Divider(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Tooltip(
                  textStyle: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  message: AppLocalizations.of(context).gender_page_explain3,
                  key: tooltipKey,
                  decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                            color: Colors.white.withAlpha(50),
                            blurStyle: BlurStyle.solid,
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                      color: DesignColors.secondaryColorDark,
                      shape: ToolTipCustomShape(bindWidgetKey: tooltipButtonKey)),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  showDuration: const Duration(seconds: 3),
                ),
                InkWell(
                    key: tooltipButtonKey,
                    customBorder: const CircleBorder(),
                    onTap: () {
                      tooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.info, color: Colors.white, size: 26),
                    )),
                Text(AppLocalizations.of(context).gender_page_explain2),
              ]),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<GenderScreenBloc, GenderScreenState>(builder: (context, state) {
                return ElevatedButton(
                    onPressed: state is GenderSelectedState
                        ? () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const RulesScreen()));
                          }
                        : null,
                    child: const Text("Continue"));
              }),
            ),
          )
        ],
      ),
    );
  }
}

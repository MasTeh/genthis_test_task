import 'package:flutter/material.dart';
import 'package:genthis_test_task/theme/app_theme.dart';

typedef SelectButtonsCallback = void Function(int index);

class SelectButtons extends StatefulWidget {
  final List<String> items;
  final SelectButtonsCallback callback;
  final int? initialValue;
  const SelectButtons({Key? key, required this.items, required this.callback, this.initialValue})
      : super(key: key);

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  int selectedItem = -1;

  @override
  void initState() {
    super.initState();

    selectedItem = widget.initialValue ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(widget.items.length, (index) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
                style: selectorButtonsTheme(index == selectedItem),
                onPressed: () {
                  setState(() {
                    selectedItem = index;
                  });
                  widget.callback(selectedItem);
                },
                child: Text(widget.items[index])),
          );
        }));
  }
}

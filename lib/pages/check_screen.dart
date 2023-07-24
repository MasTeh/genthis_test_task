import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genthis_test_task/bloc/rules_bloc.dart';
import 'package:genthis_test_task/widgets/animated_loading.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 100),
        () => context.read<RulesScreenBloc>().add(StartPhotosProccessingEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check")),
      body: BlocBuilder<RulesScreenBloc, RulesScreenState>(builder: (context, state) {
        if (state is InitialState) {
          return const Center(
              child: Text("Ожидание обработки фото", style: TextStyle(fontSize: 22)));
        }

        return ListView(children: const [
          AnimatedLoader(),
          Text("Проверяем фотографии на корректность",
              style: TextStyle(fontSize: 20), textAlign: TextAlign.center)
        ]);
      }),
    );
  }
}

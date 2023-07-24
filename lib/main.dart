import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genthis_test_task/bloc/gender_bloc.dart';
import 'package:genthis_test_task/bloc/rules_bloc.dart';
import 'package:genthis_test_task/bloc/waiting_bloc.dart';
import 'package:genthis_test_task/pages/waiting_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genthis_test_task/repository/images_api_repository.dart';
import 'package:genthis_test_task/repository/images_repository.dart';
import 'package:genthis_test_task/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WaitingScreenBloc(DummyRepository())),
        BlocProvider(create: (context) => GenderScreenBloc()),
        BlocProvider(create: (context) => RulesScreenBloc(DummyAPI()))
      ],      
      child: MaterialApp(
        title: 'Genthis test task',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: appTheme,
        home: const WaitingScreen(),  
      ),
    );
  }
}


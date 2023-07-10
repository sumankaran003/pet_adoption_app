import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:Soulmate/provider/fetch_all_pets_provider.dart';
import 'package:Soulmate/provider/fetch_history_provider.dart';
import 'package:Soulmate/provider/search_provider.dart';
import 'package:Soulmate/screens/main_page.dart';
import 'package:Soulmate/theme/dark_theme.dart';
import 'package:Soulmate/theme/light_theme.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => AdoptionHistoryProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Soulmate',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const MainPage(),

    );
  }
}

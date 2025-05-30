import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'package:jetbucks/screens/homepage.dart';
import 'package:jetbucks/screens/loginpage.dart';
import 'package:jetbucks/screens/registerpage.dart';
import 'package:jetbucks/providers/User.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 91, 37, 159),
          primary: const Color.fromARGB(255, 91, 37, 159),
          secondary: const Color.fromARGB(255, 91, 37, 159),
          tertiary: const Color.fromARGB(255, 91, 37, 159),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

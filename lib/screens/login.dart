import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({ super.key });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeProvider.instance
        )
      ],
      builder: (context, widget) {
        return MaterialApp(
          title: 'Project UTS',
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).currentThemeData,
          home: const LoginScreen(),
        );
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: themeAppBar(context, "LOGIN", _themeProvider),
      body: Container(
        child: Text("LOGIN"),
      ),
    );
  }
}


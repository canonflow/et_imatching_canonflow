import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _username = "";
  String _password = "";
  bool _obscurePassword = true;

  void doLogin() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Status"),
        content: Text("Login successful!"),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text("OK")
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData THEME = Theme.of(context);
    return Scaffold(
      backgroundColor: THEME.colorScheme.surfaceContainer,
      appBar: themeAppBar(context, "LOGIN", _themeProvider, THEME.colorScheme.surfaceContainer),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(22),
          padding: EdgeInsets.symmetric(vertical: 26, horizontal: 22),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: THEME.colorScheme.surfaceContainerLow,
            boxShadow: [
              BoxShadow(
                color: THEME.colorScheme.surfaceContainerHigh.withOpacity(0.7),
                blurRadius:20,
                spreadRadius: 2,
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "LOGIN",
                style: THEME.textTheme.headlineSmall?.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: THEME.colorScheme.onSurface
                ),
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "WELCOME TO IMATCHING GAME! 👋",
                  style: THEME.textTheme.titleMedium?.copyWith(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: THEME.colorScheme.onSecondaryContainer
                  ),
                ),
              ),
              SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please sign-in to your account and start the adventure",
                  style: THEME.textTheme.labelLarge?.copyWith(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: THEME.colorScheme.onSecondaryContainer
                        .withOpacity(0.8),
                  ),
                ),
              ),

              SizedBox(height: 22),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  hintText: "your_username",
                  floatingLabelStyle: TextStyle(color: THEME.colorScheme.onSecondaryContainer),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: THEME.colorScheme.outline,
                      width: 2.0
                    ), // when focused
                  ),
                ),
                onChanged: (v) {
                  _username = v;
                },
              ),

              SizedBox(height: 22),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "*****",
                  floatingLabelStyle: TextStyle(color: THEME.colorScheme.onSecondaryContainer),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: THEME.colorScheme.outline,
                      width: 2.0
                    ), // when focused
                  ),

                  // Icon
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                onChanged: (v) {
                  _password = v;
                },
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () {
                      doLogin();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: THEME.colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}


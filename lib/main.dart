import 'dart:convert';

import 'package:et_imatching_canonflow/constants/LocalStorageKey.dart';
import 'package:et_imatching_canonflow/models/User.dart';
import 'package:et_imatching_canonflow/providers/ThemeProvider.dart';
import 'package:et_imatching_canonflow/screens/game.dart';
import 'package:et_imatching_canonflow/screens/login.dart';
import 'package:et_imatching_canonflow/screens/result.dart';
// import 'package:et_imatching_canonflow/theme/CustomTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/themeAppBar.dart';

User? user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ThemeProvider.instance.changeTheme(ThemeEnum.LIGHT);
  await ThemeProvider.instance.loadThemeFromPrefs();

  user = await User.get();

  if (user == null) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider.instance,
        child: const MyLogin(),
      ),
    );
  } else {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider.instance,
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project UTS',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentThemeData,
      home: const MyHomePage(title: 'IMATCHING GAME'),
      routes: {
        'game': (context) => const GameScreen(),
        'result': (context) => const ResultScreen(),
        'login': (context) => const LoginScreen(),
      },
    );
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //         create: (_) => ThemeProvider.instance
    //     )
    //   ],
    //   builder: (context, widget) {
    //     return MaterialApp(
    //       title: 'Project UTS',
    //       debugShowCheckedModeBanner: false,
    //       theme: Provider.of<ThemeProvider>(context).currentThemeData,
    //       home: const MyHomePage(title: 'IMATCHING GAME'),
    //       routes: {
    //         'game': (context) => const GameScreen(),
    //         'result': (context) => const ResultScreen(),
    //         'login': (context) => const LoginScreen(),
    //       },
    //     );
    //   },
    // );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(LocalStorageKey.USERNAME);
    main();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: themeAppBar(context, widget.title, _themeProvider, Theme.of(context).colorScheme.surfaceContainer),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== HEADER ATAS =====
              Card(
                color: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onSecondary
                  ),
                  title: Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    user!.username,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary
                    ),
                  ),
                ),
              ),
        
              SizedBox(height: 35),
        
              // ===== PETUNJUK PERMAINAN =====
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // ===== TITLE =====
                    ListTile(
                      title: Center(
                        child: Text(
                          "Panduan Permainan",
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                      )
                    ),
                    // ===== CONTENT =====
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      child: Column(
                        children: [
                          // ===== IMAGE =====
                          Container(
                            width: 400,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("./assets/images/gambar-panduan.png"),
                                    fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(6)
                            ),
                          ),
        
                          const SizedBox(height: 12),
                          // ===== TEXT =====
                          Text.rich(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant
                            ),
                            TextSpan(
                              text: "Untuk memulai permainan, pemain dapat menekan tombol ",
                              children: [
                                TextSpan(
                                    text: "Play. ",
                                    style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                  text: "Pemain dapat menekan grid untuk memunculkan gambar apa yang tersembunyi di baliknya.\n\nGambar "
                                ),
                                TextSpan(
                                  text: "pertama yang diklik akan tetap muncul",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                  text: ", hingga pemain membuka grid kedua untuk mencari pasangan gambarnya.\n\nApabila, gmabar kedua adalah pasangannya, maka "
                                ),
        
                                TextSpan(
                                  text: "gambar pertama dan kedua akan terus terbuka. ",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
        
                                TextSpan(
                                  text: "Namun, apabila gambar kedua bukanlah pasangannya, maka gambar yang pertama dan kedua akan "
                                ),
        
                                TextSpan(
                                  text: "tertutup kembali.\n\n",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),

                                TextSpan(
                                  text: "Setiap level permainan harus diselesaikan dalam rentang waktu tertentu. Pembagian ukuran tebakan dan batas waktu penyelesaian ditentukan sebagai berikut:\n"
                                )
                              ],
                            )
                          ),

                          // ===== KETENTUAN =====
                          levelPoint("Level 1", "ukuran tebakan = 2x2, durasi timer = 20 detik."),
                          SizedBox(height: 6),
                          levelPoint("Level 2", "ukuran tebakan = 2x4, durasi timer = 40 detik."),
                          SizedBox(height: 6),
                          levelPoint("Level 3", "ukuran tebakan = 3x4, durasi timer = 60 detik."),

                          // ===== PENJELASAN SKOR =====
                          Text.rich(
                            TextSpan(
                              text: "\nSetiap gambar yang berhasil dicocokan dengan pasangannya memberikan ",
                              children: [
                                TextSpan(
                                  text: "skor sebesar 10 poin bagi pemain.",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                  text: " Apabila pemain kehabisan waktu, maka pemain akan dianggap "
                                ),
                                TextSpan(
                                    text: "kalah.",
                                    style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                              ]
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'game');
        },
        label: const Text(
          "Play",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17
          )
        ),
        icon: const Icon(Icons.play_arrow_outlined),
        tooltip: 'Play',
      ), // This trailing comma makes auto-formatting nicer for build methods.
      drawer: myDrawer(),
    );
  }

  Row levelPoint(String level, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.play_arrow_rounded, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              children: [
                TextSpan(
                  text: '$level ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: desc),
              ],
            ),
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user!.username,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500
              ),
            ),
            accountEmail: Text(
              "${user!.username}@gmail.com",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface
            ),
          ),
          ListTile(
            title: const Text("High score"),
            leading: const Icon(Icons.sports_score),
            onTap: () {},
          ),
          ListTile(
            title: Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                )
            ),
            leading: Icon(
                Icons.logout_rounded,
                color: Theme.of(context).colorScheme.error,
            ),
            onTap: () {
              doLogout();
            },
          ),
          ListTile(
            title: Text(
                "Result",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                )
            ),
            leading: Icon(
              Icons.receipt_rounded,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                'result',
                arguments: {
                  'score': 100,
                  'mistakes': 2,
                  'moves': 14,
                  'user': 'canonflow'
                }
              );
            },
          )
        ],
      ),
    );
  }
}

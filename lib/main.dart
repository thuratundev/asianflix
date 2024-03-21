
import 'package:asianflix/theme/theme_state.dart';
import 'package:asianflix/viewmodels/dataserviceviewmodel.dart';
import 'package:asianflix/views/mainconsolepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AsianFlixApp());
}

class AsianFlixApp extends StatelessWidget {
  const AsianFlixApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers :[
      ChangeNotifierProvider.value(value: ThemeState()),
        ChangeNotifierProvider.value(value: DataServiceViewModel()),

      ],
        child: MaterialApp(
          title: 'Matinee',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue, canvasColor: Colors.transparent),
          home: MainConsolePage(),
        ),
    );
  }
}


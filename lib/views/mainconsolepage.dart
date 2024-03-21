
import 'dart:collection';

import 'package:asianflix/utils/flix_bottom_navigation.dart';
import 'package:asianflix/utils/resources/flix_colors.dart';
import 'package:asianflix/utils/resources/flix_images.dart';
import 'package:asianflix/views/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views.dart';

class MainConsolePage extends StatefulWidget {
  const MainConsolePage({Key? key}) : super(key: key);

  @override
  _MainConsolePageState createState() => _MainConsolePageState();
}

class _MainConsolePageState extends State<MainConsolePage> {
  var _selectedIndex = 0;
  var homePage = HomePage();
  var moviePage = SeriesPage();
  var seriesPage = SeriesPage();
  late List<Widget> viewContainer;
  ListQueue<int> _navigationQueue = ListQueue();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    viewContainer = [homePage,moviePage,seriesPage,seriesPage];
  }

  void _onItemTapped(int index) async {

    if(index == 1)
      {
        var searchResult = await showSearch(context: context, delegate: SearchPage());
        return;
      }

    _navigationQueue.addLast(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) return true;
        setState(() {
          _selectedIndex = 0;
          _navigationQueue.removeLast();
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: muvi_appBackground,
        body: viewContainer[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: muvi_navigationBackground, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), offset: Offset.fromDirection(3, 1), spreadRadius: 3, blurRadius: 5)]),
          child: AppBottomNavigationBar(
            backgroundColor: muvi_navigationBackground,
            items: const <AppBottomNavigationBarItem>[
              AppBottomNavigationBarItem(
                icon: ic_home,
                title: Text('Home',style: TextStyle(color: Colors.white),)
              ),
              AppBottomNavigationBarItem(
                icon: ic_search,
              ),
              AppBottomNavigationBarItem(
                icon: ic_folder,
              ),
              AppBottomNavigationBarItem(
                icon: ic_more,
              ),
            ],
            currentIndex: _selectedIndex,
            unselectedIconTheme: IconThemeData(color: muvi_textColorPrimary, size: 22),
            selectedIconTheme: IconThemeData(color: muvi_colorPrimary, size: 22),
            onTap: _onItemTapped,
            type: AppBottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

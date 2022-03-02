import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_system_screen.dart';
import 'system_screen.dart';

const int minDistance = 80;
const int maxDistance = 160;
const int minSpeed = 1;
const int maxSpeed = 30;
const double systemCenterX = 110;
const double systemCenterY = 210;
const double sunD = 100;
const double planetD = 20;
const int minRadius = 5;
const int maxRadius = 15;

void main() {
  runApp(const PlanetSystem());
}

class PlanetSystem extends StatelessWidget {
  const PlanetSystem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Система планет',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => EditSystemManager(),
          ),
        ],
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    const SystemScreen(),
    const EditSystemScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<EditSystemManager>(
      builder: (context, editSystemManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Система',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          body: IndexedStack(
            index: editSystemManager.selectedTab,
            children: pages,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/build_planet.dart';
import 'edit_planet_screen.dart';
import 'planets_list_screen.dart';

class EditSystemManager extends ChangeNotifier {
  final _planets = <Planet>[];
  int selectedTab = 0;

  void goToSystem() {
    selectedTab = 0;
    notifyListeners();
  }

  void goToPlanets() {
    selectedTab = 1;
    notifyListeners();
  }

  List<Planet> get systemPlanets => List.unmodifiable(_planets);

  void deleteItem(int index) {
    _planets.removeAt(index);
    notifyListeners();
  }

  void addItem(Planet item) {
    String _lastPlanet = _planets.isEmpty ? '0' : _planets.last.name;
    _planets.add(item.copyWith(name: (int.parse(_lastPlanet)+1).toString()));
    notifyListeners();
  }

  void updateItem(Planet item, int index) {
    _planets[index] = item;
    notifyListeners();
  }

}

class EditSystemScreen extends StatelessWidget {
  const EditSystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EditSystemManager>(
        builder: (context, tabManager, child) {
          return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      tabManager.goToSystem();
                      //Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)
                ),
              actions: [
                TextButton(
                  child: const Text('Добавить планету',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)
                  ),
                  onPressed: () {
                    final manager = Provider.of<EditSystemManager>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPlanetScreen(
                              onCreate: (item) {
                                manager.addItem(item);
                                Navigator.pop(context);
                              },
                              onUpdate: (_) {},
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: buildSystemScreen(),
          );
        }
    );
  }

  Widget buildSystemScreen() {
    return Consumer<EditSystemManager>(
      builder: (context, manager, child) {
        if (manager.systemPlanets.isNotEmpty) {
          return PlanetsListScreen(manager: manager);
        } else {
          return const EmptySystemScreen();
        }
      },
    );
  }
}

class EmptySystemScreen extends StatelessWidget {
  const EmptySystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Text(
          'В ситеме нет планет',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
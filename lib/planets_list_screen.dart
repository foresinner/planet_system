import 'package:flutter/material.dart';
import 'edit_planet_screen.dart';
import 'edit_system_screen.dart';
import 'planet_tile.dart';

class PlanetsListScreen extends StatelessWidget {
  final EditSystemManager manager;

  const PlanetsListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final systemPlanets = manager.systemPlanets;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: systemPlanets.length,
        itemBuilder: (context, index) {
          final item = systemPlanets[index];
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            onDismissed: (direction) {
              manager.deleteItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Планета #${item.name} удалена'),
                ),
              );
            },
            child: InkWell(
              child: PlanetTile(
                key: Key(item.id),
                item: item,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPlanetScreen(
                      originalItem: item,
                      onUpdate: (item) {
                        manager.updateItem(item, index);
                        Navigator.pop(context);
                      },
                      onCreate: (_) {},
                    ),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
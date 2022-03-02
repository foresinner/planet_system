import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:testing/edit_system_screen.dart';
import 'main.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EditSystemManager>(
        builder: (context, editSystemManager, child) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/cosmos.jpg'),
                      fit: BoxFit.cover
                  )
              ),
              child: Stack(
                children: [
                  Positioned(
                      child: Container(
                        width: sunD,
                        height: sunD,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/sun3.png'),
                              fit: BoxFit.fill
                          ),
                          //shape: BoxShape.circle,
                        ),
                      ),
                      left: systemCenterX + sunD/2,
                      top: systemCenterY + sunD/2
                  ),
                  Stack(children: editSystemManager.systemPlanets, textDirection: TextDirection.ltr),
                ],
                textDirection: TextDirection.ltr,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                editSystemManager.goToPlanets();
              },
            ),
          );
        }
    );
  }
}
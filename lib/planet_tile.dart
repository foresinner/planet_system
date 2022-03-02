import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'build_planet.dart';

class PlanetTile extends StatelessWidget {
  final Planet item;
  const PlanetTile({Key? key, required this.item,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: item.color,
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Радиус (${item.radius.toString()})',
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text('Скорость (${item.speed.toString()})',
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 14.0),
              Text('#${item.name}',
                style: const TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              )
            ],
          ),
        ],
      ),
    );
  }
}
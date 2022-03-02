import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testing/build_planet.dart';
import 'package:testing/main.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'planet_tile.dart';

class EditPlanetScreen extends StatefulWidget {
  final Function(Planet) onCreate;
  final Function(Planet) onUpdate;
  final Planet? originalItem;
  final bool isUpdating;

  const EditPlanetScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _EditPlanetScreenState createState() => _EditPlanetScreenState();
}

class _EditPlanetScreenState extends State<EditPlanetScreen> {
  int _currentRadius = minRadius;
  int _currentSpeed = minSpeed;
  String _currentName = '';
  Color _currentColor = Colors.green;

  @override
  void initState() {
    super.initState();

    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _currentRadius = originalItem.radius;
      _currentSpeed = originalItem.speed;
      _currentName = originalItem.name;
      _currentColor = originalItem.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final planetItem = Planet(
                id: widget.originalItem?.id ?? const Uuid().v1(),
                radius: _currentRadius,
                speed: _currentSpeed,
                name: _currentName,
                color: _currentColor,
              );
              if (widget.isUpdating) {
                widget.onUpdate(planetItem);
              } else {
                widget.onCreate(planetItem);
              }
            },
          )
        ],
        elevation: 0.0,
        title: const Text(
          'Планета',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildRadiusField(),
            const SizedBox(height: 10.0),
            buildColorPicker(context),
            const SizedBox(height: 10.0),
            buildSpeedField(),
            const SizedBox(height: 16.0),
            PlanetTile(
              item: Planet(
                  id: 'previewMode',
                  radius: _currentRadius,
                  speed: _currentSpeed,
                  name: _currentName,
                  color: _currentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildColorPicker(BuildContext context) {
    // 1
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: _currentColor,
                borderRadius: BorderRadius.circular(50)
              ),
            ),
            const SizedBox(width: 8),
            const Text('Цвет', style: TextStyle(fontSize: 28)),
          ],
        ),
        // 3
        TextButton(
          child: const Text('Выберите'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: BlockPicker(
                      pickerColor: Colors.white,
                      onColorChanged: (color) {
                        setState(() => _currentColor = color);
                      }),
                  actions: [
                    TextButton(
                      child: const Text('Сохранить'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildRadiusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Радиус',
              style: TextStyle(fontSize: 28.0),
            ),
            const SizedBox(width: 16.0),
            Text(
              _currentRadius.toInt().toString(),
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        Slider(
          value: _currentRadius.toDouble(),
          min: minRadius.toDouble(),
          max: maxRadius.toDouble(),
          divisions: maxRadius - minRadius,
          label: _currentRadius.toInt().toString(),
          onChanged: (double value) {
            setState(() {
              _currentRadius = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget buildSpeedField() {
    // 1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Скорость',
              style: TextStyle(fontSize: 28.0),
            ),
            const SizedBox(width: 16.0),
            Text(
              _currentSpeed.toString(),
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        Slider(
          value: _currentSpeed.toDouble(),
          min: minSpeed.toDouble(),
          max: maxSpeed.toDouble(),
          divisions: maxSpeed - minSpeed,
          label: _currentSpeed.toString(),
          onChanged: (double value) {
            setState(() {
              _currentSpeed = value.toInt();
            });
          },
        ),
      ],
    );
  }
}
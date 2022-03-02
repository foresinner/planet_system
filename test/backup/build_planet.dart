import 'package:flutter/material.dart';
import 'dart:math';

import 'package:testing/main.dart';

class Planet extends StatefulWidget {
  const Planet({Key? key, required this.id, required this.radius, required this.speed,
    required this.name, required this.color}) : super(key: key);

  final String id;
  final int radius;
  final int speed;
  final String name;
  final Color color;

  Planet copyWith({
    String? id,
    int? radius,
    int? speed,
    String? name,
    Color? color,
  }) {
    return Planet(
      id: id ?? this.id,
      radius: radius ?? this.radius,
      speed: speed ?? this.speed,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  _PlanetState createState() => _PlanetState();
}

class _PlanetState extends State<Planet> with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;
  Duration _curSpeed = const Duration(seconds: 1);
  double _curRadius = 0;
  final double _offsetX = systemCenterX + sunD - planetD/2;
  final double _offsetY = systemCenterY + sunD - planetD/2;

  @override
  void initState() {
    super.initState();
    _curSpeed = Duration(seconds: widget.speed);
    _curRadius = widget.radius.toDouble();

    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.speed)
    );

    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutSine,
      reverseCurve: Curves.easeInOutSine,
      // curve: Curves.easeInOutQuad,
      // reverseCurve: Curves.easeInOutQuad,
    );

    Tween myTween = Tween<double>(begin: _offsetX - _curRadius, end: _offsetX + _curRadius);
    animation = myTween.animate(curvedAnimation);

    animation.addListener(() {
      setState(() {
        if (_curSpeed != widget.speed) {
          _curSpeed = Duration(seconds: widget.speed);
          controller.duration = _curSpeed;
        }
        if (_curRadius != widget.radius.toDouble()) {
          _curRadius = widget.radius.toDouble();
          myTween.begin = _offsetX - _curRadius;
          myTween.end = _offsetX + _curRadius;
        }
      });
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if(status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: planetD,
        height: planetD,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(planetD),
          color: widget.color,
        ),
      ),
      left: animation.value,
      top: animation.status == AnimationStatus.forward ?
      _offsetY + sqrt((widget.radius.toDouble() + _offsetX - animation.value)*(animation.value + widget.radius.toDouble() - _offsetX)) :
      _offsetY - sqrt((widget.radius.toDouble() + _offsetX - animation.value)*(animation.value + widget.radius.toDouble() - _offsetX)),
    );
  }
}

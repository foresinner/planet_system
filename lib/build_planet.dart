import 'package:flutter/material.dart';
import 'dart:math';

import 'package:testing/main.dart';

class Planet extends StatefulWidget {
  const Planet({Key? key, required this.id, required this.distance, required this.speed,
    required this.radius, required this.name, required this.color}) : super(key: key);

  final String id;
  final int distance;
  final int speed;
  final int radius;
  final String name;
  final Color color;

  Planet copyWith({
    String? id,
    int? distance,
    int? speed,
    int? radius,
    String? name,
    Color? color,
  }) {
    return Planet(
      id: id ?? this.id,
      distance: distance ?? this.distance,
      speed: speed ?? this.speed,
      radius: radius ?? this.radius,
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
  Duration _curSpeed = const Duration(seconds: minSpeed);
  double _curDistance = minDistance.toDouble();
  double _curRadius = minRadius.toDouble();
  final double _offsetX = systemCenterX + sunD;
  final double _offsetY = systemCenterY + sunD;

  @override
  void initState() {
    super.initState();
    _curSpeed = Duration(seconds: widget.speed);
    _curDistance = widget.distance.toDouble();
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

    Tween myTween = Tween<double>(
        begin: _offsetX - widget.radius.toDouble() - _curDistance,
        end: _offsetX - widget.radius.toDouble() + _curDistance
    );
    animation = myTween.animate(curvedAnimation);

    animation.addListener(() {
      setState(() {
        if (_curSpeed != widget.speed) {
          _curSpeed = Duration(seconds: widget.speed);
          controller.duration = _curSpeed;
        }
        if ((_curDistance != widget.distance.toDouble()) || (_curRadius != widget.radius.toDouble())) {
          _curDistance = widget.distance.toDouble();
          _curRadius = widget.radius.toDouble();
          myTween.begin = _offsetX - _curRadius - _curDistance;
          myTween.end = _offsetX - _curRadius + _curDistance;
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
        width: widget.radius.toDouble()*2,
        height: widget.radius.toDouble()*2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius.toDouble()*2),
          color: widget.color,
        ),
      ),
      left: animation.value,
      top: animation.status == AnimationStatus.forward ?
      //_offsetY + sqrt((widget.radius.toDouble() + _offsetX - animation.value)*(animation.value + widget.radius.toDouble() - _offsetX)) :
      _offsetY - widget.radius.toDouble() + sqrt((widget.distance.toDouble() + _offsetX - widget.radius.toDouble() - animation.value)*
          (animation.value + widget.distance.toDouble() - _offsetX + widget.radius.toDouble())) :
      //_offsetY - sqrt((widget.radius.toDouble() + _offsetX - animation.value)*(animation.value + widget.radius.toDouble() - _offsetX)),
      _offsetY - widget.radius.toDouble() - sqrt((widget.distance.toDouble() + _offsetX - widget.radius.toDouble() - animation.value)*
          (animation.value + widget.distance.toDouble() - _offsetX + widget.radius.toDouble())),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:twenty_forty_seven/color.dart';

class Tile extends StatefulWidget {
  String number;
  double width, height;
  int color;
  double fontSize;

  Tile(this.number, this.width, this.height, this.color, this.fontSize);

  @override
  State<StatefulWidget> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          widget.number,
          style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: Color(ColorCustom.tileTextColor)),
        ),
      ),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: Color(widget.color),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }
}

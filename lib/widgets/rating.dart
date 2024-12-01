import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const Rating({super.key, required this.rating});

  final int rating;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    List<Widget> container = [];
    Color color = Theme.of(context).colorScheme.secondary;
    if (widget.rating > 0) {
      color = Colors.red;
    }
    if (widget.rating > 2) {
      color = Colors.deepOrangeAccent;
    }
    if (widget.rating > 3) {
      color = Colors.amber;
    }
    color = color.harmonizeWith(Theme.of(context).colorScheme.primary);

    Icon star = Icon(
      Icons.star,
      size: Theme.of(context).textTheme.headlineSmall!.fontSize,
      color: color,
    );
    Icon starEmpty = Icon(
      Icons.star_border,
      size: Theme.of(context).textTheme.headlineSmall!.fontSize,
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
    );
    if (widget.rating > 0) {
      container.add(star);
    }
    if (widget.rating > 1) {
      container.add(star);
    }
    if (widget.rating > 2) {
      container.add(star);
    }
    if (widget.rating > 3) {
      container.add(star);
    }
    if (widget.rating > 4) {
      container.add(star);
    }

    int needsToBeFilled = 4 - container.length;
    for (int i = 0; i <= needsToBeFilled; i++) {
      container.add(starEmpty);
    }

    return Row(
      children: container,
    );
  }
}

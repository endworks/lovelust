import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class RatingSelect extends StatefulWidget {
  const RatingSelect(
      {super.key, required this.rating, required this.onRatingUpdate});

  final int rating;
  final Function(int value) onRatingUpdate;

  @override
  State<RatingSelect> createState() => _RatingSelectState();
}

class _RatingSelectState extends State<RatingSelect> {
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
      color: color,
    );
    Icon starEmpty = Icon(
      Icons.star_border,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
    );

    for (int i = 0; i < 5; i++) {
      container.add(IconButton(
        onPressed: () => widget.onRatingUpdate(i + 1),
        icon: widget.rating > i ? star : starEmpty,
        padding: const EdgeInsets.all(2),
        constraints: const BoxConstraints(),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: container,
    );
  }
}

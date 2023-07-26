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
    Icon star = Icon(
      Icons.star,
      color: Theme.of(context).colorScheme.secondary,
    );
    Icon starEmpty = Icon(
      Icons.star_border,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
    );

    for (int i = 0; i < 5; i++) {
      container.add(
        Container(
          padding: const EdgeInsets.all(0.0),
          width: 36, // you can adjust the width as you need
          child: IconButton(
            onPressed: () => widget.onRatingUpdate(i + 1),
            icon: widget.rating > i ? star : starEmpty,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: container,
    );
  }
}

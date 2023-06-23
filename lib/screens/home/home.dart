import 'package:flutter/material.dart';
import 'package:lovelust/widgets/big_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const BigHeader(
            title: Row(children: [
              Text('Love',
                  style: TextStyle(color: Color.fromARGB(255, 252, 85, 147))),
              Text('Lust',
                  style: TextStyle(color: Color.fromARGB(255, 93, 89, 217))),
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return const Center(
                  child: Text(
                    '#TODO',
                    textScaleFactor: 3,
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

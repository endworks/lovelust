import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions(BuildContext context) {
    return [
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Index 0: Activity:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      )),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Index 1: Partners:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      )),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Index 2: Stats:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      )),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Index 3: Learn:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      )),
    ];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _widgetOptions(context)[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Activity',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.group),
            icon: Icon(Icons.group_outlined),
            label: 'Partners',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.monitor_heart),
            icon: Icon(Icons.monitor_heart_outlined),
            label: 'Stats',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'Learn',
          ),
        ],
      ),
    );
  }
}
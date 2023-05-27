import 'package:flutter/material.dart';
import 'package:lovelust/models/destination.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key, required this.destination});

  final Destination destination;

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text('${destination.title} AlertDialog'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headlineSmall = Theme.of(context).textTheme.headlineSmall!;
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: destination.color,
      visualDensity: VisualDensity.comfortable,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      textStyle: headlineSmall,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${destination.title} RootPage - /'),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              child: const Text('Push /list'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: _buildDialog,
                );
              },
              child: const Text('Local Dialog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  useRootNavigator: true,
                  builder: _buildDialog,
                );
              },
              child: const Text('Root Dialog'),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          child: Text(
                            '${destination.title} BottomSheet\n'
                            'Tap the back button to dismiss',
                            style: headlineSmall,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Local BottomSheet'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

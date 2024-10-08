import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  static const String routeName = '/explore';

  static navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('E$index'),
            ),
            title: Text('Explore Item $index'),
            subtitle: Text('Subtitle $index'),
          );
        },
      ),
    );
  }
}

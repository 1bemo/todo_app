import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  final String _titleAppBar = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(_titleAppBar),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const Text('MainS Screen',style: TextStyle(color: Colors.white),),
          ElevatedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/todo');
              },
              child: const Text('Go Next')
          )
        ],
      ),
    );
  }
}

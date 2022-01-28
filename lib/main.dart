import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:movies_scrapper/src/screens/home.dart';

void main(List<String> args) {
  runApp(const ScrapperMovies());
}

// root widget class
class ScrapperMovies extends StatelessWidget {
  const ScrapperMovies({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrapper Music',
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
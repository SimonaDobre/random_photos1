import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Random Photos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //  https://api.unsplash.com/photos/random?client_id=aUVN87gQaqyNSaxa7n-ttt9ZDVe9ceAjjU1fTG2FF0c&count=5

  bool isLoading = true;
  List<RandomPhoto> allPhotosList = <RandomPhoto>[];

  @override
  void initState() {
    super.initState();
    getRandomPhotos();
  }

  Future<void> getRandomPhotos() async {
    final Response response = await get(Uri.parse(
        'https://api.unsplash.com/photos/random?client_id=aUVN87gQaqyNSaxa7n-ttt9ZDVe9ceAjjU1fTG2FF0c&count=20'));
    //final List<Map<dynamic, dynamic>> photosList = jsonDecode(response.body) as List<Map<dynamic, dynamic>>;
    //final List<Map<dynamic, dynamic>> photosList =List<Map<dynamic, dynamic>>.from(jsonDecode(response.body) as List<Map<dynamic, dynamic>>);

    final List<Map<dynamic, dynamic>> photosList =
        (jsonDecode(response.body) as List).cast(); //<Map<dynamic, dynamic>>;

    for (int i = 0; i < photosList.length; i++) {
      final Map<dynamic, dynamic> currentPhoto = photosList[i];
      //print('í = $i , $currentPhoto);
      final String currentID = currentPhoto['id'] as String;
      final Map<String, dynamic> allURLs = currentPhoto['urls'] as Map<String, dynamic>;
      final String largeURL = allURLs['full'] as String;
      final String smallURL = allURLs['small'] as String;
      final RandomPhoto photo = RandomPhoto(currentID, smallURL, largeURL);
      allPhotosList.add(photo);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: allPhotosList.length,
        itemBuilder: (BuildContext context, int index) {
          if (isLoading) {
            return const CircularProgressIndicator();
          } else {
            final String currentPhotoSmallURL = allPhotosList[index].smallURL;

            return SizedBox(
              width: MediaQuery.of(context).size.width / 2.2,
              height: 150,
              child: Image.network(currentPhotoSmallURL),
            );
          }
        },
      ),
    );
  }
}

class RandomPhoto {
  RandomPhoto(this.id, this.smallURL, this.fullURL);

  final String id;
  final String smallURL;
  final String fullURL;
}

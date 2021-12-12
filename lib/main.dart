import 'package:flutter/material.dart';
import 'dart:async';
import 'package:html/parser.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future fetchData() async {
  var _url = 'https://www.lesswrong.com/library';
  // _url = 'https://github.com';
  var header = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
    "Access-Control-Allow-Origin, Origin, Content-Type, X-Amz-Date, Authorization, X-Api-Key, X-Amz-Security-Token, locale",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
  };

  final response = await http
      .get(Uri.parse(_url), headers: header);

  if (response.statusCode == 200) {
    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    // If the server did return a 200 OK response,
    // then parse the JSON.
    var document = parse(response.body);
    String get_text(document, class_name, number){
      String ret = '';
      try{
        ret = document.getElementsByClassName(class_name)[number].innerHtml;
      }
      catch(e){
        ret = '';
      }
      return ret;
    }

    int get_length(document, class_name){
      return document.getElementsByClassName(class_name).length;
    }

    List list_title = [
      'TabNavigationItem-navText',
      'TabNavigationSubItem-root',
      'SectionTitle-title',
      'Typography-root',
      'Typography-title',
      'Typography-display1',
      'CollectionsCard-title',
      'CollectionsCard-mergeTitle',
      'UsersNameDisplay-userName',
      'BigCollectionsCard-text',
      'Typography-body2',
      'BigCollectionsCard-title',
      'SequencesGridItem-title',
      'LinkCard-background',
    ];

    Map map_titles = {
      'menu_class': 'TabNavigationItem-navText',
      'sub_menu_class': 'TabNavigationSubItem-root',
      'big_title': 'SectionTitle-title',
      'small_title': 'SequencesGridItem-title',
    };
    Map map_values = {};

    String menu_class = 'TabNavigationItem-navText';
    String sub_menu_class = 'TabNavigationSubItem-root';
    String big_title = 'SectionTitle-title';
    String small_title = 'SequencesGridItem-title';

    // for (int i=0; i < map_titles.length - 1; i++)
    for (var _class in map_titles.keys) {
      // List<String> _temp = [];
      map_values[_class] = <String>[];
      for (int i = 0; i < get_length(document, map_titles[_class]) - 1; i++) {
        // print("${_class} $i  ${get_text(document, map_titles[_class], i)}");
        map_values[_class].add(get_text(document, map_titles[_class], i));
            // .add(get_text(document, map_titles[_class], i));
      }
      // map_values[_class] = List;

    }
    print(map_values);
    // Typography-root Typography-display1 SectionTitle-title
    // Typography-root Typography-title BigCollectionsCard-title
    // SequencesGridItem-root LinkCard-root
    // Typography-root Typography-title CollectionsCard-title CollectionsCard-mergeTitle
    // Typography-root Typography-body2 BigCollectionsCard-text


    var doc_str = {'menu': ['', ''] };

    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future future_fetch;

  @override
  void initState() {
    super.initState();
    future_fetch = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: future_fetch,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
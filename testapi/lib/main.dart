import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Iterable<SubCategories>> fetchCategories() async {
  final res = await http.post(
    Uri.parse(
        'https://admin.clickomart.navybits.com/api/v1/categories/get_all_categories'),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: '22D196EC5C6F345377A67AD9F4BDDF',
    },
  );
  // debugPrint(res.body);
  final List<dynamic> responseJson = jsonDecode(res.body)["response"];
  late Iterable<SubCategories> allCategories = responseJson
      .map((subCategoryJson) => SubCategories.fromJson(subCategoryJson));

  return allCategories;
}

class SubCategories {
  String id;
  String name;
  String logo;
  Iterable<SubCategories>? subCategories;

  SubCategories({
    required this.id,
    required this.name,
    required this.logo,
    this.subCategories,
  });

  factory SubCategories.fromJson(Map<String, dynamic> json) {
    Iterable<SubCategories>? subCats;
    if (json['subcategories'] != null) {   
      subCats = (json['subcategories'] as List<dynamic>)
          .map((oneSub) => SubCategories.fromJson(oneSub));
    }

    return SubCategories(
        id: json['_id'],
        name: json['name'],
        logo: json['logo'] ?? '',
        subCategories: subCats);
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Iterable<SubCategories>> futureCategories;
  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Iterable<SubCategories>>(
              future: futureCategories,
              builder: (context, snapshot) {
                //1st
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) => Column(
                      children: [
                        Text(snapshot.data!.elementAt(index).name),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: ((context, indexSubCategories) => Text(
                              snapshot.data!
                                  .elementAt(index)
                                  .subCategories!
                                  .elementAt(indexSubCategories)
                                  .name)),
                          itemCount: snapshot.data!
                              .elementAt(index)
                              .subCategories!
                              .length,
                        )
                      ],
                    ),
                    // Text(snapshot.data!.elementAt(index).name),
                    //2nd
                    // Text(snapshot.data!.elementAt(index).subCategories!.elementAt(index).name),
                    itemCount: snapshot.data?.length,
                  );
                } else {
                  return const Text("empty");
                }
              }),
        ),
      ),
    );
  }
}

// handling
// zid images
// zabbetla shakla name title 3 items per 1 column
// Move the work to clickomart
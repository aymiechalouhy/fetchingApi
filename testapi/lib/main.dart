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
  debugPrint(res.body);
  // if (res.statusCode == 200) {
  //   return SubCategories.fromJson(jsonDecode(res.body));
  // } else {
  //   throw Exception('Failed to load Categories');
  // }
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
    Iterable<SubCategories> subCats =
        (json['subcategories'] as List<dynamic>)
            .map((oneSub) => SubCategories.fromJson(oneSub));
    return SubCategories(
        id: json['_id'],
        name: json['name'],
        logo: json['logo'] ?? '',
        subCategories:subCats);
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
              // var showData = json.decode(snapshot.data.toString());
              return ListView.builder(
                itemBuilder: (context, index) =>
                    Text(snapshot.data!.elementAt(index).name),
                itemCount: snapshot.data?.length,
              );
            },
          ),
        ),
        //       FutureBuilder<SubCategories>(
        //       future: futureCategories,
        //         builder: (context, snapshot) {
        //          var showData = json.decode(snapshot.data.toString());
        //           return GridView.builder(
        //             physics: const ScrollPhysics(),
        //             shrinkWrap: true,
        //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: 3,
        //                 mainAxisSpacing: 20,
        //                 crossAxisSpacing: 4),
        //             itemBuilder: (context, index) => Padding(
        //               padding: const EdgeInsets.only(top: 0),
        //               child: SingleChildScrollView(
        //                 child: InkWell(
        //                   child: (Column(
        //                     children:  [
        //                       Padding(
        //                         padding: const EdgeInsets.only(top: 4),
        //                         child: Text(
        //                           showData[index]['name'].toString(),
        //                           style: const TextStyle(
        //                             fontSize: 10,),),
        //                       ),
        //                     ],
        //                   )),
        //                 ),
        //               ),
        //             ),
        //          //   itemCount: showData.length,
        //          );
        //        },
        // ),
      ),
    );
  }
}
// awwal shi bedde shouf l fare2 bayna w ben l documentation (output[dynamic, list])
// tene shi lezim a3rif enno 3melna map metel ma 3melna >models >listCategories
// zid images
//zabbetla shakla name title 3 items per 1 column
//Move the work to clickomart
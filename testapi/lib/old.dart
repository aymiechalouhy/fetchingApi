
import 'package:flutter/material.dart';
import 'dart:convert';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);
  @override
  State<Categories> createState() => _CategoriesState();
}
class _CategoriesState extends State<Categories> {
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar()
        ,
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                var showData = json.decode(snapshot.data.toString());
                return GridView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 4),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SingleChildScrollView(
                      child: InkWell(           
                        child: (Column(
                          children: [
                            Image.network(
                              showData[index]['logo'],
                              height: 100,
                              width: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                showData[index]['name'],
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                  itemCount: showData.length,
                );
              },
              future: DefaultAssetBundle.of(context)
                  .loadString("assets/images/categories.json"),
            ),
           ]),
        ),
      ),
    );
  }
}
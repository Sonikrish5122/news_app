import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/NewsView.dart';
import 'dart:convert';

import 'model.dart';

class NewsCategory extends StatefulWidget {
  String Query;
  NewsCategory({required this.Query});
  @override
  State<NewsCategory> createState() => _CategoryState();
}

class _CategoryState extends State<NewsCategory> {
  List<NewsQueryModel> newsModelList = [];
  bool isLoading = true;

  Future<void> getNewsByQuery(String query) async {
    String url = "";
    if (query == "Top News" || query == "India") {
      url =
          'https://newsapi.org/v2/top-headlines?country=in&apiKey=bb6cc93c07674fa2b86880f33a8ad95f';
    } else {
      String apiKey = 'bb6cc93c07674fa2b86880f33a8ad95f';
      url = 'https://newsapi.org/v2/top-headlines?q=$query&apiKey=$apiKey';
    }

    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data); // Debugging print statement
    setState(() {
      data['articles'].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
      });
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.Query,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(newsModelList[index].articleUrl)));
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      newsModelList[index].imageUrl,
                                      fit: BoxFit.fitHeight,
                                      height: 230,
                                      width: double.infinity,
                                    )),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 10, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              child: Text(
                                                newsModelList[index].title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              newsModelList[index]
                                                          .description
                                                          .length >
                                                      50
                                                  ? "${newsModelList[index].description.substring(0, 55)}...."
                                                  : newsModelList[index]
                                                      .description,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          ],
                                        )))
                              ],
                            )),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

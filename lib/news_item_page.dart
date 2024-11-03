import 'dart:convert';
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 
import 'newsItem.dart'; 
import '../widgets/bb.dart';



class NewsItemPage extends StatelessWidget{

  final int id; // final cannot modify id / late can modify id 
  NewsItemPage(this.id, {super.key}); 
  @override
  Widget build(BuildContext context){
    Future<NewsItem> ni =  fetch(id); 
    return Scaffold(
      appBar: AppBar(title: const Text("News Item Page")), 
      body: FutureBuilder(
        future: ni, 
        builder: (context, snapshot){
         if (snapshot.hasData){
          return Text(snapshot.data!.text);  // snapshot.data is ni in this case 
         }
         else{
          return BB("loading item"); 
         }
        },
      ), 
    ); 
  }
}

// Async 이기에, Future<NewsItem> 을 사용해야 한다 
Future <NewsItem> fetch(int id) async{
  String root = "https://hacker-news.firebaseio.com/v0/";
  final url = Uri.parse('${root}item/${id}.json');
  final response = await http.get(url);
  Map<String,dynamic> theItem = jsonDecode(response.body);
  NewsItem ni = NewsItem.fromJson( theItem );
  return ni; 
}
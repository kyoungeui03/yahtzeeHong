
import 'package:flutter_application_1/models/card_model.dart'; 

class DrawModel {
  final int remaining; 
  final List<CardModel> cards; 

  DrawModel({
  required this.remaining, 
  this.cards = const[],}); 

  factory DrawModel.fromJson(Map<String, dynamic> json){
    // Get Cards
    final cards = json['cards']
        .map<CardModel>((card) => CardModel.fromJson(card))
        .toList();

    return DrawModel(
      remaining: json['remaining'], cards: cards); 
  }
}
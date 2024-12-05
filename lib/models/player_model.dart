
import 'package:flutter_application_1/models/card_model.dart'; 

class PlayerModel {
  final String name; 
  final bool isHuman; 
  int coin; 
  int betCoin; 
  List<CardModel> cards; 
  bool previousWinner; // decides which player will start first at the next round 
  bool playerFolded; 

  PlayerModel({
  required this.name, 
  this.isHuman = false, 
  this.cards = const[],
  // total coin  
  this.coin = 4900,
  // bet coin (every new game, players need to bet 100)
  this. betCoin =100,
  this.previousWinner = false,
  this.playerFolded = false,} 
  ); 
  

  addCards(List<CardModel> newcards){
    // add current cards & newcards (combining 2 lists)
    cards = [...cards, ...newcards]; 
  }

  // remove a card 
  removeCard(CardModel card){
    cards.removeWhere((c)=>c.value == card.value && c.suit==card.suit); 
  }

  // Ask Bot Or Human 
  bool get isBot{return !isHuman;}
}
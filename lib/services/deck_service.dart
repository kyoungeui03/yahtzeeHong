
import 'package:flutter_application_1/models/draw_model.dart';
import 'package:flutter_application_1/services/api_service.dart'; 
import 'package:flutter_application_1/models/deck_model.dart';

class DeckService extends ApiService {

  Future<DeckModel> newDeck([int deckCount =1]) async{
    final data = await httpget(
      'deck/new/shuffle', 
      params:{'deck_count':deckCount},);
      return DeckModel.fromJson(data); 
  }

  Future<DeckModel> newCustomDeck() async {
    final data = await httpget(
      'deck/new/shuffle',
      params: {
        'cards': 'AS,2S,3S,4S,5S,6S,7S,8S,9S,0S,AH,2H,3H,4H,5H,6H,7H,8H,9H,0H',
      },
    );
    return DeckModel.fromJson(data);
  }

  Future<DrawModel> drawCards(DeckModel deck, {int count =1}) async{
    final data = await httpget(
      '/deck/${deck.deck_id}/draw',
      params: {'count':count}, 
      ); 

    return DrawModel.fromJson(data); 
  }
}
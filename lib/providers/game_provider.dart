
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/popup_text.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/card_model.dart';
import 'package:flutter_application_1/models/deck_model.dart';
import 'package:flutter_application_1/models/player_model.dart';
import 'package:flutter_application_1/models/turn_model.dart';
import 'package:flutter_application_1/screens/start_screen.dart';
import 'package:flutter_application_1/services/deck_service.dart';
import 'dart:math'; 
 

abstract class GameProvider with ChangeNotifier{

  GameProvider(){
    _service = DeckService();}

  late DeckService _service; 
  late Turn _turn; 
  Turn get turn => _turn; 
  // proxy to get access to the Deck as Public 
  DeckModel? _currentDeck; 
  DeckModel? get currentDeck => _currentDeck; 

  List<PlayerModel> _players = []; 
  List<PlayerModel> get players => _players; 
 
  // Sets Up The Board 
  Future<void> setBoard(List<PlayerModel> players) async{
    
    print("Setting up the board...");

  // Debug: Print out who the previous winner is
  for (var player in players) {
    print("${player.name} - Previous Winner: ${player.previousWinner}");
  }

    final deck = await _service.newCustomDeck(); 
    _currentDeck = deck; // set our deck 
    _players = players; 

    // decides which player is starting first based on who won the previous game 
    final startingPlayer = players[0].previousWinner? players[0]:players[1]; 
    final startingIndex = players.indexOf(startingPlayer);
    _turn = Turn(
    players: players, 
    currentPlayer: startingPlayer, 
    startingIndex: startingIndex);

    // Deal cards one at a time to each player
    for (int i = 0; i < 2; i++) { // Number of cards to deal
    for (var player in players) {
      await Future.delayed(const Duration(milliseconds: 500)); // Delay between each card
      await drawCards(player, count: 1, allowAnyTime: true); // Draw one card at a time
      notifyListeners(); // Notify to update UI
    }
  }
    // reveal only player's card
    revealAllCards(players[0]); 
    //round change 
    textPopUpEffects(); 
    notifyListeners();

    if(startingPlayer.isBot){
      print("AI starting first, Bot Turn"); 
      await botTurn(); 
    }
  }

   // Draws the Cards 
  Future<void> drawCards(PlayerModel player, {int count =1, bool allowAnyTime=false}) async{
    // No Deck Or Cannot Draw Card 
    if (currentDeck == null){return;}
    if(!canDrawCard && !allowAnyTime){return;}
    final draw = await _service.drawCards(_currentDeck!, count:count); 
    // add the cards 
    player.addCards(draw.cards); 
    _turn.drawCount += count; 
    currentDeck!.remaining = draw.remaining; 
    notifyListeners(); 
  }

  // Reveal All Cards 
  void revealAllCards(PlayerModel player){
    for (var card in player.cards){
      card.isRevealed = true; 
    }
    notifyListeners(); 
  }

  // Reveal One Card Randomly 
  void revealOneRandomCard(PlayerModel player) {
  final hiddenCards = player.cards.where((card) => !card.isRevealed).toList();
  if (hiddenCards.isNotEmpty) {
    final random = Random();
    final randomCard = hiddenCards[random.nextInt(hiddenCards.length)];
    randomCard.isRevealed = true; // Reveal the chosen card
    notifyListeners(); // Notify UI to update
  }
}

  // Reveals the last card 
  void revealLastCard(PlayerModel player){
    player.cards.last.isRevealed = true;
    notifyListeners(); 
  }

  // only draw 2
  bool get canDrawCard{
    return turn.drawCount < 2; 
  }

  // Game is Over turn.currentPlayer.name 
  bool get gameIsOver{
    return (turn.currentPlayer.coin==0) || (turn.otherPlayer.coin==0); 
  }

  // Handles Round Counting, "ALL IN", "Not Enough Coin", WIN, LOSE, VICTORY, etc
  Future<void> textPopUpEffects() async {
    
  print("Current Round: ${turn.currentRound}, Previous Round: ${turn.previousRound}");

  // Helper function to show popup messages
  Future<void> showPopup(String message, {int delay = 1}) async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (_) => PopupText(message: message),
    );
    await Future.delayed(Duration(seconds: delay));
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  // Show round message
  if (turn.currentRound - turn.previousRound == 1) {
    final roundMessages = ["- Round 1 -", "- Round 2 -", "- Final Round -"];
    if (turn.currentRound >= 1 && turn.currentRound <= 3) {
      await showPopup(roundMessages[turn.currentRound - 1]);
    }
    turn.previousRound++; 
    notifyListeners();
  }

  // Show ALL IN message
  if (turn.currentPlayer.coin == 0 || turn.otherPlayer.coin == 0) {
    await showPopup("ALL IN!");
    notifyListeners();
  }

  // Show round result message
  if (turn.roundEnded) {
    final message = players[0].previousWinner ? "YOU WIN" : "YOU LOSE";
    await showPopup(message, delay: 2);
    notifyListeners();
  }

  // Show game over message and navigate to StartScreen
  if (gameIsOver) {
    final message = players[0].previousWinner ? "VICTORY" : "DEFEAT";
    await showPopup(message, delay: 2);

    Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const StartScreen()),
      (route) => false,
    );
  }
}

  void showToast(String message, {int seconds = 3, SnackBarAction? action}){
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message), 
        duration: Duration(seconds:seconds),
         action: action),
    );
  }

  // resets the whole round state for the next game 
  void resetRound(){
    print("Resetting Round"); 
    // Reset Player States 
    for (var player in players){
      player.betCoin = 100; 
      player.coin -= player.betCoin; 
      player.cards.clear(); 
      player.playerFolded =false; 
    }
    // reset draw & action counts 
    _turn.drawCount = 0; 
    _turn.actionCount = 0; 
    _turn.currentRound = 1; 
    _turn.previousRound =0;  
    _turn.turnCount=0; 
    _turn.roundEnded = false; 
    notifyListeners(); 
  }

  // matches opponents betCoin value or bets nothing 
  void match(){
    if(turn.currentPlayer.isHuman){
      print("Human Decided to Match"); 
    }
    // Each round first turn, Player can hold and give opponent an opportunity to bet
    if(turn.turnCount == 0){
      turn.turnCount++; 
      endTurn(); 
    }
    else{ 
    int matchAmount = (turn.otherPlayer.betCoin - turn.currentPlayer.betCoin); 

    // All-In Occurred 
    /*if(turn.currentPlayer.coin < matchAmount){
      turn.currentPlayer.betCoin += turn.currentPlayer.coin; 
      turn.currentPlayer.coin =0; 
      turn.turnCount++; 
      textPopUpEffects(); 
      return; 
    }*/

    turn.currentPlayer.betCoin += matchAmount; 
    turn.currentPlayer.coin -= matchAmount;  
    
    if (turn.currentRound ==1){
      turn.currentRound++; 
      textPopUpEffects(); 
      endTurn(); 
      revealOneRandomCard(players[1]); 
      notifyListeners(); 
    }
    else if(turn.currentRound ==2){
      turn.currentRound++; 
      textPopUpEffects(); 
      endTurn(); 
      notifyListeners(); 
    }
    // Final Round
    else if(turn.currentRound ==3){
      turn.roundEnded = true; 
      allSet(); 
    }
    turn.turnCount =0; 
    }
  }

  // loses all betCoin & starts the new Round 
  void fold(){
    turn.currentPlayer.playerFolded = true;
    turn.roundEnded = true; 
    allSet(); 
  }

  // raise the coin (For Human) 
  void raise(int raisedAmount){
    bool canEndTurn = false; 

    if(raisedAmount ==0){
      showToast("Cannot Enter 0"); 
    }
    else if(raisedAmount % 100 !=0){
      showToast("Raised Amount Should Be In Hundreds"); 
    }
    else{
    int totalRaisedAmount = (turn.otherPlayer.betCoin - turn.currentPlayer.betCoin) + raisedAmount; 

    if(turn.currentPlayer.coin < totalRaisedAmount){
      showToast("Not Enough Coin"); 
    }
    else if(turn.currentPlayer.coin == totalRaisedAmount){
      turn.currentPlayer.coin =0; 
      turn.currentPlayer.betCoin += totalRaisedAmount; 
      canEndTurn = true; 
      textPopUpEffects(); 
    }
    else{
      turn.currentPlayer.coin -= totalRaisedAmount; 
      turn.currentPlayer.betCoin += totalRaisedAmount; 
      canEndTurn = true; 
    }}
    if(canEndTurn){
      turn.turnCount++; 
      notifyListeners(); 
      endTurn(); 
    }
  }

  // Raise the Coin (For AI)

 void raiseAI() {
  print("AI attempting to raise...");
  final player = turn.currentPlayer;
  if (!player.isBot) {
    print("Error: Non-AI player is trying to act in AI turn.");
    return;
  }
  final random = Random();
  final percentage = 10 + random.nextInt(41); // 10-50 Random

  int raiseAmount = ((player.coin * percentage) / 100).floor();
  raiseAmount -= raiseAmount % 100;

  if (raiseAmount > 0 && raiseAmount <= player.coin) {
    print("AI raising by $raiseAmount.");
    raise(raiseAmount);
  } else {
    print("AI cannot raise, defaulting to match.");
    match();
  }
}

  // Error Handle Function 
  int cardValue(String value){
    switch (value) {
      case "A":
        return 1; // Ace as 1
      default:
        return int.tryParse(value) ?? 0; // Convert numeric values or default to 0
    }
  }

  // Calculates Players' Deck 
  int calculateValue(PlayerModel player){

    // Pair 
    if (player.cards[0].value == player.cards[1].value){
      return (cardValue(player.cards[0].value) + cardValue(player.cards[1].value)) % 10 + 10; 
    }
    // Non-Pair
    else{
      return (cardValue(player.cards[0].value) + cardValue(player.cards[1].value)) % 10;

    }
  }

  // Determines the Winner & Starts a New Round 
  void determineWinner(){
  bool playerWin = true;

  // Fetch current and other players
  final currentPlayer = turn.currentPlayer;
  final otherPlayer = turn.otherPlayer;

  // Calculate values
  int currentPlayerValue = calculateValue(currentPlayer);
  int otherPlayerValue = calculateValue(otherPlayer);

  // Debugging Information
  print("Current Player Value: $currentPlayerValue, Other Player Value: $otherPlayerValue");
  print("Current Player Folded: ${currentPlayer.playerFolded}, Other Player Folded: ${otherPlayer.playerFolded}");

  // Fold Case
  if (currentPlayer.playerFolded) {
    print("${currentPlayer.name} Folded");
    playerWin = false;
  } 
  else if (otherPlayer.playerFolded) {
    print("${otherPlayer.name} Folded");
    playerWin = true;
  } 
  else if (currentPlayerValue > otherPlayerValue) {
    print("${currentPlayer.name} Won by Value");
    playerWin = true;
  } 
  else if (currentPlayerValue < otherPlayerValue) {
    print("${otherPlayer.name} Won by Value");
    playerWin = false;
  } 
  else if(currentPlayerValue == otherPlayerValue){
    playerWin = true; 
  }
  // Adjust Coins and Winner Status
  if (playerWin) {
    print("${currentPlayer.name} Won. Adjusting Coins...");
    currentPlayer.coin += currentPlayer.betCoin + otherPlayer.betCoin;
    currentPlayer.previousWinner = true;
    otherPlayer.previousWinner = false;
  } else {
    print("${otherPlayer.name} Won. Adjusting Coins...");
    otherPlayer.coin += currentPlayer.betCoin + otherPlayer.betCoin;
    currentPlayer.previousWinner = false;
    otherPlayer.previousWinner = true;
  }
}

  // Handles the Tie Breaker 
  Future<bool> tieBreaker() async{
    await drawCards(players[0], count:1, allowAnyTime: true,);
    await Future.delayed(const Duration(milliseconds: 500));  
    await drawCards(players[1], count:1, allowAnyTime: true,); 

    revealAllCards(players[0]); 
    revealLastCard(players[1]); 
    notifyListeners(); // Update UI for new cards

    await Future.delayed(const Duration(seconds: 1)); // Delay to show the tie-breaker reveal

    int playerCardValue = int.parse(players[0].cards.last.value);
    int computerCardValue = int.parse(players[1].cards.last.value);
    if (playerCardValue > computerCardValue ||
      (playerCardValue == computerCardValue &&
          players[0].cards.last.suit == Suit.Spades)){
            return true; 
          }
    else{return false;}
  }

  // Sets For the Next Round 
  Future<void> allSet() async{
    print("ALL SET IS RUNNING");
    revealAllCards(players[0]); 
    await Future.delayed(const Duration(seconds: 1)); // Simulate AI thinking
    revealAllCards(players[1]);
    await Future.delayed(const Duration(seconds: 1)); // Simulate AI thinking
    determineWinner(); 
    turn.roundEnded = true; 
    textPopUpEffects(); 
    resetRound(); 
    setBoard(players); 
    notifyListeners(); 
  }

 void endTurn() {

  _turn.nextTurn(); // Move to the next turn
  print("End turn: Current player is ${_turn.currentPlayer.name}, isBot=${_turn.currentPlayer.isBot}");

  // Check if the next player is AI and trigger their turn
  if (_turn.currentPlayer.isBot) {
    print("End turn: AI's turn next.");
    botTurn();
  } 
  else {
    print("End turn: Human player's turn.");
    notifyListeners(); // Only notify if it's the human player's turn
  }
}


  // Either Raise / Hold / Fold 
Future<void> botTurn() async {
  print("AI Turn: ${turn.currentPlayer.name}");
  await Future.delayed(const Duration(seconds: 2)); // Simulate AI thinking

  // Calculate the AI's hand value
  int aiHandValue = calculateValue(turn.currentPlayer);
  double expectedValue = aiHandValue / 30.0; // Normalize hand value between 0 and 1

  print("AI Hand Value: $aiHandValue");
  print("AI Expected Value: $expectedValue");

  // Generate a random number for probabilistic decision-making
  double randomDecision = Random().nextDouble();
  print("AI Random Decision Value: $randomDecision");

  // Decision-making logic based on probabilities
  if (expectedValue > 0.8) {
    // Strong hand: 70% Raise, 20% Match, 10% Fold
    if (randomDecision < 0.7) {
      print("AI decides to RAISE (Strong hand).");
      raiseAI();
    } else if (randomDecision < 0.9) {
      print("AI decides to MATCH (Strong hand).");
      match();
    } else {
      print("AI decides to FOLD (Strong hand).");
      fold();
    }
  } else if (expectedValue > 0.5) {
    // Moderate hand: 50% Match, 30% Raise, 10% Fold
    if (randomDecision < 0.4) {
      print("AI decides to RAISE (Moderate hand).");
      raiseAI();
    } else if (randomDecision < 0.9) {
      print("AI decides to MATCH (Moderate hand).");
      match();
    } else {
      print("AI decides to FOLD (Moderate hand).");
      fold();
    }
  } else {
    // Weak hand: 10% Raise, 40% Match, 50% Fold
    if (randomDecision < 0.1) {
      print("AI decides to RAISE (Weak hand).");
      raiseAI();
    } else if (randomDecision < 0.5) {
      print("AI decides to MATCH (Weak hand).");
      match();
    } else {
      print("AI decides to FOLD (Weak hand).");
      fold();
    }
  }

  print("AI Turn Complete.");
  notifyListeners();
}

}




import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/card_list.dart';
import 'package:flutter_application_1/components/deck_pile.dart';
import 'package:flutter_application_1/models/player_model.dart';
import 'package:flutter_application_1/providers/pair_play_provider.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Consuming & Listening to the Updates
    return Consumer<PairPlayProvider>(
      builder: (context, model, child) {
        return model.currentDeck != null
            ? Stack(
                children: [
                  // Deck Pile and Bet Coin Boxes
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await model.drawCards(model.turn.currentPlayer);
                          },
                          child: DeckPile(remaining: model.currentDeck!.remaining),
                        ),
                        const SizedBox(width: 16),

                        // Vertical Column for Bet Coin Boxes
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Computer's BetCoin Box
                            Container(
                              width: 113,
                              height: 75,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.red[900],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "AI",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    model.players[1].betCoin.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),

                            // Player's BetCoin Box
                            Container(
                              width: 113,
                              height: 75,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "KY",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    model.players[0].betCoin.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Top: Computer Information and Cards
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Computer Name Box
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  model.players[1].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Computer Coin Box
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on, color: Colors.yellow),
                                    const SizedBox(width: 5),
                                    Text(
                                      model.players[1].coin.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Computer Card List
                          CardList(player: model.players[1]),
                        ],
                      ),
                    ),
                  ),

                  // Bottom: Player Information with Buttons and Cards
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // Player Name Box
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  model.players[0].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Player Coin Box
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on, color: Colors.yellow),
                                    const SizedBox(width: 5),
                                    Text(
                                      model.players[0].coin.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Player Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Prompt the user to input the raise amount
                                    showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController raiseController =
                                            TextEditingController();
                                        return AlertDialog(
                                          backgroundColor: Colors.black, // Black background
                                          title: const Text(
                                            'Enter Raise Amount',
                                            style: TextStyle(
                                              color: Colors.white, // White text
                                            ),
                                          ),
                                          content: TextField(
                                            controller: raiseController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Raise Amount',
                                              hintStyle: TextStyle(color: Colors.white54), // Hint text
                                            ),
                                            style: const TextStyle(color: Colors.white), // Input text
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                int? raiseAmount =
                                                    int.tryParse(raiseController.text);
                                                if (raiseAmount != null) {
                                                  context
                                                      .read<PairPlayProvider>()
                                                      .raise(raiseAmount);
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Raise',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    side: const BorderSide(color: Colors.black, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "RAISE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<PairPlayProvider>().match();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.black, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "MATCH / HOLD",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<PairPlayProvider>().fold();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "FOLD",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Player Card List
                          CardList(player: model.players[0]),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Loading ...",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

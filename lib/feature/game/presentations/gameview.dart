import 'dart:math';
import 'package:flutter/material.dart';
import 'package:games/core/model/player.dart';

class GameViewState extends StatefulWidget {
  const GameViewState({super.key});

  @override
  State<GameViewState> createState() => _GameViewStateState();
}

class _GameViewStateState extends State<GameViewState> {
  late Player bishop;
  late Player rook;
  bool isBishopTurn = true;
  List<(int, int)> currentHints = [];

  final String bishopIcons = "♝";
  final String rookIcons = "♜";

  late String bishopEmoji;
  late String rookEmoji;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    final rnd = Random();
    var p1 = getRandPos();
    var p2 = getRandPos();

    while (p1 == p2) {
      p2 = getRandPos();
    }

    bishopEmoji = bishopIcons[rnd.nextInt(bishopIcons.length)];
    rookEmoji = rookIcons[rnd.nextInt(rookIcons.length)];

    bishop = Player(
      playerType: PlayerType.bishop,
      color: Colors.red,
      id: 'bishop',
      xPos: p1.$1,
      yPos: p1.$2,
    );

    rook = Player(
      playerType: PlayerType.rook,
      color: Colors.blue,
      id: 'rook',
      xPos: p2.$1,
      yPos: p2.$2,
    );

    isBishopTurn = true;
    updateHints();
    setState(() {});
  }

  (int, int) getRandPos() {
    final r = Random();
    return (r.nextInt(8), r.nextInt(8));
  }

  void updateHints() {
    final plyr = isBishopTurn ? bishop : rook;
    currentHints = getMoves(plyr);
  }

  List<(int, int)> getMoves(Player plyr) {
    List<(int, int)> mvs = [];
    var x = plyr.xPos;
    var y = plyr.yPos;
    final other = isBishopTurn ? rook : bishop;

    bool blocked(int cx, int cy) => (cx == other.xPos && cy == other.yPos);

    if (plyr.playerType == PlayerType.bishop) {
      for (int i = 1; x - i >= 0 && y - i >= 0; i++) {
        if (blocked(x - i, y - i)) break;
        mvs.add((x - i, y - i));
      }
      for (int i = 1; x - i >= 0 && y + i < 8; i++) {
        if (blocked(x - i, y + i)) break;
        mvs.add((x - i, y + i));
      }
      for (int i = 1; x + i < 8 && y - i >= 0; i++) {
        if (blocked(x + i, y - i)) break;
        mvs.add((x + i, y - i));
      }
      for (int i = 1; x + i < 8 && y + i < 8; i++) {
        if (blocked(x + i, y + i)) break;
        mvs.add((x + i, y + i));
      }
    } else {
      for (int i = x - 1; i >= 0; i--) {
        if (blocked(i, y)) break;
        mvs.add((i, y));
      }
      for (int i = x + 1; i < 8; i++) {
        if (blocked(i, y)) break;
        mvs.add((i, y));
      }
      for (int i = y - 1; i >= 0; i--) {
        if (blocked(x, i)) break;
        mvs.add((x, i));
      }
      for (int i = y + 1; i < 8; i++) {
        if (blocked(x, i)) break;
        mvs.add((x, i));
      }
    }

    return mvs;
  }

  void onCellTap(int x, int y) {
    var t = (x, y);
    if (!currentHints.contains(t)) return;

    var current = isBishopTurn ? bishop : rook;
    current.xPos = x;
    current.yPos = y;

    isBishopTurn = !isBishopTurn;
    updateHints();
    setState(() {});
  }

  Color? getCellColor(int x, int y) {
    if (x == bishop.xPos && y == bishop.yPos) return bishop.color;
    if (x == rook.xPos && y == rook.yPos) return rook.color;

    for (var move in currentHints) {
      if (move == (x, y)) {
        return isBishopTurn ? Colors.red.shade100 : Colors.blue.shade100;
      }
    }
    return Colors.white;
  }

  String? getCellEmoji(int x, int y) {
    if (x == bishop.xPos && y == bishop.yPos) return bishopEmoji;
    if (x == rook.xPos && y == rook.yPos) return rookEmoji;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("8x8 Bishop & Rook Game")),
      floatingActionButton: FloatingActionButton(
        onPressed: initGame,
        child: Icon(Icons.refresh),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            itemCount: 64,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: (ctx, idx) {
              var x = idx ~/ 8;
              var y = idx % 8;

              return GestureDetector(
                onTap: () => onCellTap(x, y),
                child: Container(
                  decoration: BoxDecoration(
                    color: getCellColor(x, y),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      getCellEmoji(x, y) ?? "",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

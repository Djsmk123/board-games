import 'dart:ui';

enum PlayerType { bishop, rook }

class Player {
  final PlayerType playerType;
  final Color color;
  final String id;
  int xPos;
  int yPos;

  Player({
    required this.playerType,
    required this.color,
    required this.id,
    required this.xPos,
    required this.yPos,
  });
}

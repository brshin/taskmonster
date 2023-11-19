import 'package:flutter/material.dart';
import 'player.dart';
import 'dart:math';

class Enemy {
  late String imagePath;
  late DateTime battleDate;
  late String name;
  late String description;
  late bool defeated;
  late int strength;
  late int hp;
  late int attack;
  late BattleResults battleResults;

  String get image => imagePath;

  Enemy({
      required this.imagePath,
      required this.battleDate,
      required this.name,
      required this.description,
      required this.defeated,
      required this.strength,
      required this.hp,
      required this.attack,
      required this.battleResults,
  });

  static BattleResults generateBattleResults(String playerImagePath, String enemyImagePath, int damageDealt,
    double damageTaken) {
      return BattleResults(
        playerImagePath: playerImagePath,
        enemyImagePath: enemyImagePath,
        damageDealt: damageDealt,
        damageTaken: damageTaken,
        completed: false,
        victory: false,
      );
  }

  static Enemy generateEnemy(String name, String description, DateTime date) {
    String imagePath = "";
    int strength = 0;
    int i = Random().nextInt(6);
    switch (i) {
      case 0:
        imagePath = 'assets/images/test_dragon.jpg';
        strength = 5;
        break;
      case 1:
        imagePath = 'assets/images/test_eagle.jpg';
        strength = 4;
        break;
      case 2:
        imagePath = 'assets/images/test_goblin.jpg';
        strength = 2;
        break;
      case 3:
        imagePath = 'assets/images/test_octopus.jpg';
        strength = 1;
        break;
      case 4:
        imagePath = 'assets/images/test_serpent.jpg';
        strength = 3;
        break;
      case 5:
        imagePath = 'assets/images/test_wolf.jpg';
        strength = 2;
        break;
    }
    return Enemy(
      imagePath: imagePath,
      battleDate: date,
      name: name,
      description: description,
      defeated: false,
      strength: strength,
      hp: strength * 6,
      attack: strength,
      battleResults: generateBattleResults("", "", 0, 0));
  }

  battle(Player pl) {
    int originalEnemyHp = hp;
    double defenseModifier = 1 + 0.05 * pl.defense;
    double realHp = pl.hp * defenseModifier;
    while (realHp > 0 && hp > 0) {
      pl.hp -= attack;
      hp -= pl.attack;
    }
    if (realHp <= 0) {
      battleResults.victory = false;
    } else {
      battleResults.victory = true;
    }
    battleResults.playerImagePath = 'assets/images/test_octopus.jpg';
    battleResults.enemyImagePath = image;
    battleResults.damageDealt = originalEnemyHp - hp;
    battleResults.damageTaken = pl.hp * defenseModifier - realHp;
    hp = originalEnemyHp; // in case objects are reused
    battleResults.completed = true;
  }

 Map<String, dynamic> toJson() {
   return {
     'imagePath': imagePath,
     'battleDate': battleDate.toIso8601String(),
     'name': name,
     'description': description,
     'defeated': defeated,
     'strength': strength,
     'hp': hp,
     'attack': attack,
     'battleResults': battleResults.toJson(),
   };
 }

 factory Enemy.fromJson(Map<String, dynamic> json) {
   return Enemy(
     imagePath: json['imagePath'],
     battleDate: DateTime.parse(json['battleDate']),
     name: json['name'],
     description: json['description'],
     defeated: json['defeated'],
     strength: json['strength'],
     hp: json['hp'],
     attack: json['attack'],
     battleResults: BattleResults.fromJson(json['battleResults']),
   );
 }

}

class BattleResults {
  late String playerImagePath;
  late String enemyImagePath;
  late int damageDealt;
  late double damageTaken;
  late bool completed;
  late bool victory;

  BattleResults({
      required this.playerImagePath,
      required this.enemyImagePath,
      required this.damageDealt,
      required this.damageTaken,
      required this.completed,
      required this.victory,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerImagePath': playerImagePath,
      'enemyImagePath': enemyImagePath,
      'damageDealt': damageDealt,
      'damageTaken': damageTaken,
      'completed': completed,
      'victory': victory,
    };
  }

  factory BattleResults.fromJson(Map<String, dynamic> json) {
      return BattleResults(
          playerImagePath: json['playerImagePath'],
          enemyImagePath: json['enemyImagePath'],
          damageDealt: json['damageDealt'],
          damageTaken: json['damageTaken'],
          completed: json['completed'],
          victory: json['victory'],
      );
  }
}

void showBattleResults(BuildContext context, BattleResults br) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          (br.victory) ? 'VICTORY' : 'DEFEAT',
          style: const TextStyle(fontSize: 20),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                ImageIcon(
                  AssetImage(br.playerImagePath),
                  size: 24.0,
                ),
                Text(
                  'Damage Dealt: ${br.damageDealt}',
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
                Text(
                  'Damage Taken: ${br.damageTaken}',
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.black,
              thickness: 1,
            ),
            Column(
              children: <Widget>[
                Text(
                  'Damage Dealt: ${br.damageTaken}',
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
                Text(
                  'Damage Taken: ${br.damageDealt}',
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                ),
                ImageIcon(
                  AssetImage(br.enemyImagePath),
                  size: 24.0,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget enemyWidget(BuildContext context, Enemy en) {
  return Row(
    children: <Widget>[
      if (en.battleResults.completed)
        IconButton(
          icon: const Icon(Icons.adjust_sharp),
          onPressed: () => showBattleResults(context, en.battleResults),
          iconSize: 20,
        ),
      ImageIcon(
        AssetImage(en.image),
        size: 48.0,
      ),
      const SizedBox(
          width: 10), // Add some space between the image and the number
      Text(
        en.strength.toString(),
        style: const TextStyle(fontSize: 20),
      ),
    ],
  );
}

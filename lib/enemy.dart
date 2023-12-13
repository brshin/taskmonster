import 'package:flutter/material.dart';
import 'player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  static BattleResults generateBattleResults(String playerImagePath,
      String enemyImagePath, int damageDealt, double damageTaken) {
    return BattleResults(
      playerImagePath: 'assets/images/test_knight.jpg',
      enemyImagePath: enemyImagePath,
      damageDealt: damageDealt,
      damageTaken: damageTaken,
      completed: false,
      victory: false,
      exp: 0,
      battlePerformance: 0,
    );
  }

  static Enemy generateEnemy(
      String name, String description, DateTime date, int stars) {
    String imagePath = "";
    int strength = stars;
    int i = 2 * strength + Random().nextInt(1);
    int attack = strength;
    switch (i) {
      case 1:
        imagePath = 'assets/images/test_octopus.jpg';
        attack = 2;
        break;
      case 2:
        imagePath = 'assets/images/test_spider.jpg';
        attack = 3;
        break;
      case 3:
        imagePath = 'assets/images/test_wolf.jpg';
        attack = 4;
        break;
      case 4:
        imagePath = 'assets/images/test_serpent.jpg';
        attack = 5;
        break;
      case 5:
        imagePath = 'assets/images/test_goblin.jpg';
        attack = 6;
        break;
      case 6:
        imagePath = 'assets/images/test_eagle.jpg';
        attack = 7;
        break;
      case 7:
        imagePath = 'assets/images/test_rhino.jpg';
        attack = 8;
        break;
      case 8:
        imagePath = 'assets/images/test_golem.jpg';
        attack = 9;
        break;
      case 9:
        imagePath = 'assets/images/test_yeti.jpg';
        attack = 10;
        break;
      default:
        imagePath = 'assets/images/test_dragon.jpg';
        attack = 12;
        break;
    }
    return Enemy(
        imagePath: imagePath,
        battleDate: date,
        name: name,
        description: description,
        defeated: false,
        strength: strength,
        hp: strength * 3 + 5,
        attack: attack,
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
    battleResults.playerImagePath = 'assets/images/test_knight.jpeg';
    battleResults.enemyImagePath = image;
    battleResults.damageDealt = originalEnemyHp - hp;
    battleResults.damageTaken = pl.hp * defenseModifier - realHp;
    hp = originalEnemyHp; // in case objects are reused
    battleResults.completed = true;
    // calculates battle score
    battleResults.exp = strength * strength;
    battleResults.battlePerformance =
        ((battleResults.damageDealt / battleResults.damageTaken) * 2.5).toInt();
    if (battleResults.battlePerformance > 5) {
      battleResults.battlePerformance = 5;
    }
    if (battleResults.battlePerformance < 1) {
      battleResults.battlePerformance = 1;
    }
    pl.reward(this);
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
  late int exp;
  late int battlePerformance;

  BattleResults({
    required this.playerImagePath,
    required this.enemyImagePath,
    required this.damageDealt,
    required this.damageTaken,
    required this.completed,
    required this.victory,
    required this.exp,
    required this.battlePerformance,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerImagePath': playerImagePath,
      'enemyImagePath': enemyImagePath,
      'damageDealt': damageDealt,
      'damageTaken': damageTaken,
      'completed': completed,
      'victory': victory,
      'exp': exp,
      'battlePerformance': battlePerformance,
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
      exp: json['exp'],
      battlePerformance: json['battlePerformance'],
    );
  }
}

Future<void> showBattleResults(BuildContext context, BattleResults br) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return SizedBox(
              height: height - 400,
              width: width - 400,
              child: Column(
                children: <Widget>[
                  Text(
                    (br.victory) ? 'VICTORY' : 'DEFEAT',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text('Reward: ${br.exp} gold!',
                      style: const TextStyle(fontSize: 18)),
                  Text('Reward: ${br.exp} experience!',
                      style: const TextStyle(fontSize: 18)),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/test_knight.jpg",
                        width: 150.0,
                        height: 150.0,
                      ),
                      Image.asset(
                        br.enemyImagePath,
                        width: 150.0,
                        height: 150.0,
                      ),
                    ],
                  ),
                  RatingBarIndicator(
                    rating: br.battlePerformance.toDouble(),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),

              //   Text('Reward: ${br.exp} gold', style: const TextStyle(fontSize: 18))
              // Text('Reward: ${br.exp} exp')
            );
          })));
  return Future(() => null);
}

Widget enemyWidget(BuildContext context, Enemy en, Player pl) {
  double stars2 = en.strength.toDouble(); // avoid naming same
  return Row(
    children: <Widget>[
      const SizedBox(width: 10),
      if (en.battleResults.completed)
        IconButton(
          icon: Icon(Icons.electric_bolt),
          onPressed: () => showBattleResults(context, en.battleResults),
        ),
      // Image widget
      Image.asset(
        en.image,
        width: 48.0,
        height: 48.0,
      ),
      const SizedBox(
          width: 10), // Add some space between the image and the number
      // Text widget
      RatingBarIndicator(
        rating: stars2,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemCount: 5,
        itemSize: 50.0,
        direction: Axis.horizontal,
      ),
      /*
      Text(
        en.strength.toString(),
        style: const TextStyle(fontSize: 20),
      ),
      */
    ],
  );
}

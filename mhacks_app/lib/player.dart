import 'package:flutter/material.dart';
import 'dart:math';
import 'enemy.dart';

//hello
class Player {
  int attack;
  int defense;
  int hp;
  int level;
  int exp;
  int gold;
  String rank;
  int expThreshold = 100;
  List<String> items = [];

  Player({
    this.attack = 1,
    this.defense = 1,
    this.hp = 1,
    this.level = 1,
    this.exp = 0,
    this.gold = 0,
    this.rank = 'Scout',
    this.expThreshold = 100,
    this.items = const [],

    //constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'attack': attack,
      'defense': defense,
      'hp': hp,
      'level': level,
      'exp': exp,
      'gold': gold,
      'rank': rank,
      'expThreshold': expThreshold,
      'items': items,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      attack: json['attack'],
      defense: json['defense'],
      hp: json['hp'],
      level: json['level'],
      exp: json['exp'],
      gold: json['gold'],
      rank: json['rank'],
      expThreshold: json['expThreshold'],
      items: List<String>.from(json['items']),
    );
  }

  void reward(Enemy e) {
    gold += e.strength * e.strength;
    exp += e.strength * e.strength;
  }

  void _update_rank() {
    if (level >= 30) {
      rank = 'Eagle';
    }
    if (level >= 25) {
      rank = 'Life';
    }
    if (level >= 20) {
      rank = 'Star';
    } else if (level >= 15) {
      rank = 'First Class';
    } else if (level >= 10) {
      rank = 'Second Class';
    } else if (level >= 5) {
      rank = 'Tenderfoot';
    } else {
      rank = 'Scout';
    }
  }

  void _update_level() {
    int statIncrease = 2;

    level += 1;
    attack += statIncrease;
    defense += statIncrease;
    hp += statIncrease;
/* 
for loop to do this...

level*0.2 * stat_increase += every stat

60% of level up stats will be fixed (20% goes to each stat)

the remaining 40% is randomly distributed:

for each level*0.4()
    one random stat increase

*/
  }

  void random_stat(int value) {
    for (int i = 0; i < value; i++) {
      var random = Random();
      var number =
          random.nextInt(3) + 1; // Generate a random number between 1 and 3

      switch (number) {
        case 1:
          this.attack += 1;
          break;
        case 2:
          this.defense += 1;
          break;
        case 3:
          this.hp += 1;
          break;
        default:
          print('Invalid number');
      }
    }
  }

  void _add_exp(int value) {
    exp += value;
    //check here

    if (exp >= expThreshold) {
      _update_level();
      exp = exp - expThreshold;
    }
  }

  void _add_hp(int value) {
    hp += value;
  }

  void _add_attack(int value) {
    attack += value;
  }

  void _add_defense(int value) {
    defense += value;
  }

  void _add_gold(int value) {
    gold += value;
  }

  bool _subtract_gold(int value) {
    int goldDiff = gold - value;
    if (goldDiff >= 0) {
      gold -= value;
      return true;
    } else {
      return false;
    }
  }

  void _subtract_hp(int value) {
    hp -= value;
  }

  void _subtract_attack(int value) {
    attack -= value;
  }

  void _subtract_defense(int value) {
    defense -= value;
  }

  void updateValues(
      {required int attack,
      required int defense,
      required int hp,
      required int level,
      required String rank}) {
    this.attack = attack;
    this.defense = defense;
    this.hp = hp;
    this.level = level;
    this.rank = rank;
  }
}

class PlayerScreen {
  Player currentPlayer = Player();

  PlayerScreen(Player p) {
    currentPlayer = p;
  }

  Future<void> show(BuildContext context) {
    return showDialog(
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
                        'Rank: ${currentPlayer.rank}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Level: ${currentPlayer.level}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Exp: ${currentPlayer.exp}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Gold: ${currentPlayer.gold}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'HP: ${currentPlayer.hp}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Defense: ${currentPlayer.defense}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Attack: ${currentPlayer.attack}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ));
            })));
  }
}

import 'main.dart';

class Currency {
  int gold;

  Currency({
    required this.gold,
  });

  void rewardUser(Task task) {
    if (task.isCompletedOnTime()) {
      addGold(10);
    }
  }

  void addGold(int amount) {
    gold += amount;
  }

  void subtractGold(int amount) {
    if (gold - amount >= 0) {
      gold -= amount;
    }
  }

  bool canAfford(int amount) {
    return gold >= amount;
  }

  int getGold() {
    return gold;
  }
}

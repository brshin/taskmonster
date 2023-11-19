import 'package:flutter/material.dart';
import 'player.dart';

class ItemStat {
  late int attackBoost;
  late int defenseBoost;
  late int healthBoost;
  late bool consumable;
  late int price;
  late int unlockLevel;

  ItemStat({
    required this.attackBoost,
    required this.defenseBoost,
    required this.healthBoost,
    required this.consumable,
    required this.price,
    required this.unlockLevel,
  });
}

class Shop {
  // master shop map of all possible items
  // KEY: Item name, VALUE: Unlock level
  static Map<String, ItemStat> master = {
    'Sword': ItemStat(
        attackBoost: 1,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 10,
        unlockLevel: 1),
    'Health Potion': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 3,
        consumable: true,
        price: 5,
        unlockLevel: 1),
    'Axe': ItemStat(
        attackBoost: 2,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 25,
        unlockLevel: 2),
    'Shield': ItemStat(
        attackBoost: 0,
        defenseBoost: 2,
        healthBoost: 0,
        consumable: false,
        price: 25,
        unlockLevel: 2),
    'Fire Staff': ItemStat(
        attackBoost: 4,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 50,
        unlockLevel: 3),
    'Elixir': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 9,
        consumable: false,
        price: 50,
        unlockLevel: 3),
    'Chain Mail': ItemStat(
        attackBoost: 0,
        defenseBoost: 3,
        healthBoost: 0,
        consumable: false,
        price: 130,
        unlockLevel: 4),
    'Amulet of Power': ItemStat(
        attackBoost: 4,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 170,
        unlockLevel: 4),
    'Dimensional Robe': ItemStat(
        attackBoost: 0,
        defenseBoost: 3,
        healthBoost: 3,
        consumable: false,
        price: 180,
        unlockLevel: 5),
    'Excalibur': ItemStat(
        attackBoost: 6,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 200,
        unlockLevel: 5),
  };

  static const Map<String, int> masterShopMap = {
    'Basic Sword': 1,
    'Health Potion': 1,
    'Axe': 2,
    'Shield': 2,
    'Fire Staff': 3,
    'Elixir': 3,
    'Chain Mail': 4,
    'Amulet of Power': 4,
    'Dimensional Robes': 5,
    'Excalibur': 5,
  };

  // contains the prices of all items, with the name as the key
  // KEY: Item name, VALUE: Item cost
  static const Map<String, int> costMap = {
    'Basic Sword': 10,
    'Health Potion': 5,
    'Axe': 25,
    'Shield': 25,
    'Fire Staff': 50,
    'Elixir': 50,
    'Chain Mail': 130,
    'Amulet of Power': 170,
    'Dimensional Robes': 180,
    'Excalibur': 200,
  };

  // temporary shop map of items currently available
  // KEY: Item name, VALUE: Unlock level
  // INVARIANT: subset of masterShopMap
  late Map<String, int> current;

  Shop(Map<String, ItemStat> c) {
    current = masterShopMap;
  }

// this should determine current based on user inventory and experience
  Shop.namedConstructor(Player user) {
    current = masterShopMap;
  }

  // prototype of display function
  Future<void> displayShop(BuildContext context, Player player) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return SizedBox(
                    height: height - 400,
                    width: width - 400,
                    child: ListView.builder(
                      itemCount: current.length,
                      itemBuilder: (context, index) {
                        var item = current.entries.elementAt(index);
                        if (itemAvailable(item.key, player)) {
                          return ShopItem(
                            itemName: item.key,
                            itemPrice: costMap[item.key] ?? -1,
                            onPressed: () => purchaseItem(item.key, player),
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // Return an empty widget if the item is not available
                        }
                      },
                    ),
                  );
                },
              ),
            ));
  }

  // determines whether an item is available, based on the player's level
  bool itemAvailable(String item, Player player) {
    int playerLevel = player.level;
    int requiredLevel = masterShopMap[item] ?? 1;
    return playerLevel >= requiredLevel;
  }

  // determines whether an item can be bought by a given player
  bool itemAffordable(String item, Player player) {
    int cost = costMap[item] ?? -1;
    if (cost == -1) {
      return false;
    } else {
      return (player.gold - cost > 0);
    }
  }

  // returns a boolean that shows whether the transaction went through or not
  bool purchaseItem(String item, Player player) {
    int cost = costMap[item] ?? -1;
    if (!itemAffordable(item, player)) {
      return false;
    } else {
      player.gold -= cost;
      int statUp = cost ~/ 5;
      player.random_stat(statUp);
      player.items.add(item);
      current.remove(item);
      return true;
    }
  }
}

class ShopItem extends StatelessWidget {
  final String itemName;
  final int itemPrice;
  final VoidCallback onPressed;

  const ShopItem({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(itemName),
      subtitle: Text('\$${itemPrice.toString()}'),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: onPressed,
      ),
    );
  }
}

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
  Map<String, ItemStat> shopMap = {
    'Sword': ItemStat(1, 0, 0, false, 10, 1),
    'Apple': ItemStat(0, 0, 2, true, 10, 2),
    'Shield': ItemStat(0, 2, 0, false, 20, 3),
    'Health Potion': ItemStat(0, 0, 7, true, 15, 4),
    'Magic Wand': ItemStat(3, 0, 0, false, 30, 5),
    'Helmet': ItemStat(0, 3, 0, false, 25, 6),
    'Gold Sword': ItemStat(5, 0, 0, false, 40, 7),
    'Bow': ItemStat(3, 0, 0, false, 35, 8),
    'Mana Elixir': ItemStat(0, 0, 8, true, 20, 9),
    'Diamond Sword': ItemStat(7, 0, 0, false, 60, 10),
    'Platinum Shield': ItemStat(0, 5, 0, false, 50, 11),
    'Enchanted Robe': ItemStat(0, 3, 0, false, 40, 12),
    'Dagger': ItemStat(5, 0, 0, false, 35, 13),
    'Crystal Ball': ItemStat(1, 1, 1, true, 40, 14),
    'Steel Armor': ItemStat(0, 7, 0, false, 45, 15),
    'Fire Staff': ItemStat(8, 0, 0, false, 50, 16),
    'Elixir of Wisdom': ItemStat(0, 0, 10, true, 55, 17),
    'Invisibility Cloak': ItemStat(3, 3, 0, true, 60, 18),
    'Thunder Hammer': ItemStat(10, 0, 0, false, 65, 19),
    'Phoenix Feather': ItemStat(0, 0, 15, true, 70, 20),
    'Ice Blade': ItemStat(10, 0, 0, false, 75, 21),
    'Dragon Scale Armor': ItemStat(0, 10, 0, false, 80, 22),
    'Vortex Orb': ItemStat(0, 0, 20, true, 85, 23),
    'Shadow Cloak': ItemStat(5, 5, 0, false, 90, 24),
    'Mystic Bow': ItemStat(10, 0, 0, false, 95, 25),
    'Amulet of Power': ItemStat(15, 0, -10, true, 100, 26),
    'Celestial Staff': ItemStat(18, -5, 0, false, 105, 27),
    'Titanium Shield': ItemStat(0, 15, -10, false, 110, 28),
    'Dimensional Robes': ItemStat(0, 0, 25, true, 115, 29),
    'Excalibur': ItemStat(25, 0, 0, false, 200, 30),
  };

  // temporary shop map of items currently available
  // KEY: Item name, VALUE: Unlock level
  // INVARIANT: subset of masterShopMap
  late Map<String, int> currentShopMap;

  Shop(Map<String, int> current) {
    currentShopMap = current;
  }

  Shop.namedConstructor(Player user) {
    currentShopMap = costMap;
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
                  return Container(
                    height: height - 400,
                    width: width - 400,
                    child: ListView.builder(
                      itemCount: currentShopMap.length,
                      itemBuilder: (context, index) {
                        var item = currentShopMap.entries.elementAt(index);
                        if (itemAvailable(item.key, player)) {
                          return ShopItem(
                            itemName: item.key,
                            itemPrice: costMap[item.key] ?? -1,
                            onPressed: () => purchaseItem(item.key, player),
                          );
                        } else {
                          return SizedBox
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
      player.items.add(item);
      currentShopMap.remove(item);
      return true;
    }
  }
}

class ShopItem extends StatelessWidget {
  final String itemName;
  final int itemPrice;
  final VoidCallback onPressed;

  ShopItem({
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
        icon: Icon(Icons.add_shopping_cart),
        onPressed: onPressed,
      ),
    );
  }
}
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
    'Apple': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 2,
        consumable: true,
        price: 10,
        unlockLevel: 2),
    'Shield': ItemStat(
        attackBoost: 0,
        defenseBoost: 2,
        healthBoost: 0,
        consumable: false,
        price: 20,
        unlockLevel: 3),
    'Health Potion': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 7,
        consumable: true,
        price: 15,
        unlockLevel: 4),
    'Magic Wand': ItemStat(
        attackBoost: 3,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 30,
        unlockLevel: 5),
    'Helmet': ItemStat(
        attackBoost: 0,
        defenseBoost: 3,
        healthBoost: 0,
        consumable: false,
        price: 25,
        unlockLevel: 6),
    'Bow': ItemStat(
        attackBoost: 3,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 35,
        unlockLevel: 8),
    'Mana Elixir': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 8,
        consumable: true,
        price: 20,
        unlockLevel: 9),
    'Diamond Sword': ItemStat(
        attackBoost: 7,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 60,
        unlockLevel: 10),
    'Platinum Shield': ItemStat(
        attackBoost: 0,
        defenseBoost: 5,
        healthBoost: 0,
        consumable: false,
        price: 50,
        unlockLevel: 11),
    'Enchanted Robe': ItemStat(
        attackBoost: 0,
        defenseBoost: 3,
        healthBoost: 0,
        consumable: false,
        price: 40,
        unlockLevel: 12),
    'Dagger': ItemStat(
        attackBoost: 5,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 35,
        unlockLevel: 13),
    'Crystal Ball': ItemStat(
        attackBoost: 1,
        defenseBoost: 1,
        healthBoost: 1,
        consumable: true,
        price: 40,
        unlockLevel: 14),
    'Steel Armor': ItemStat(
        attackBoost: 0,
        defenseBoost: 7,
        healthBoost: 0,
        consumable: false,
        price: 45,
        unlockLevel: 15),
    'Fire Staff': ItemStat(
        attackBoost: 8,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 50,
        unlockLevel: 16),
    'Elixir of Wisdom': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 10,
        consumable: true,
        price: 55,
        unlockLevel: 17),
    'Invisibility Cloak': ItemStat(
        attackBoost: 3,
        defenseBoost: 3,
        healthBoost: 0,
        consumable: true,
        price: 60,
        unlockLevel: 18),
    'Thunder Hammer': ItemStat(
        attackBoost: 10,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 65,
        unlockLevel: 19),
    'Phoenix Feather': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 15,
        consumable: true,
        price: 70,
        unlockLevel: 20),
    'Ice Blade': ItemStat(
        attackBoost: 10,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 75,
        unlockLevel: 21),
    'Dragon Scale Armor': ItemStat(
        attackBoost: 0,
        defenseBoost: 10,
        healthBoost: 0,
        consumable: false,
        price: 80,
        unlockLevel: 22),
    'Vortex Orb': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 20,
        consumable: true,
        price: 85,
        unlockLevel: 23),
    'Shadow Cloak': ItemStat(
        attackBoost: 5,
        defenseBoost: 5,
        healthBoost: 0,
        consumable: false,
        price: 90,
        unlockLevel: 24),
    'Mystic Bow': ItemStat(
        attackBoost: 10,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 95,
        unlockLevel: 25),
    'Amulet of Power': ItemStat(
        attackBoost: 15,
        defenseBoost: 0,
        healthBoost: -10,
        consumable: true,
        price: 100,
        unlockLevel: 26),
    'Celestial Staff': ItemStat(
        attackBoost: 18,
        defenseBoost: -5,
        healthBoost: 0,
        consumable: false,
        price: 105,
        unlockLevel: 27),
    'Titanium Shield': ItemStat(
        attackBoost: 0,
        defenseBoost: 15,
        healthBoost: -10,
        consumable: false,
        price: 110,
        unlockLevel: 28),
    'Dimensional Robes': ItemStat(
        attackBoost: 0,
        defenseBoost: 0,
        healthBoost: 25,
        consumable: true,
        price: 115,
        unlockLevel: 29),
    'Excalibur': ItemStat(
        attackBoost: 25,
        defenseBoost: 0,
        healthBoost: 0,
        consumable: false,
        price: 200,
        unlockLevel: 30),
  };

  // temporary shop map of items currently available
  // KEY: Item name, VALUE: Unlock level
  // INVARIANT: subset of masterShopMap
  late Map<String, ItemStat> current;

  Shop(Map<String, ItemStat> c) {
    current = c;
  }

// this should determine current based on user inventory and experience
  Shop.namedConstructor(Player user) {
    current = current;
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
                            itemPrice: master[item.key]?.price ?? -1,
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
    int requiredLevel = master[item]?.unlockLevel ?? 1;
    return playerLevel >= requiredLevel;
  }

  // determines whether an item can be bought by a given player
  bool itemAffordable(String item, Player player) {
    int cost = master[item]?.price ?? -1;
    if (cost == -1) {
      return false;
    } else {
      return (player.gold - cost > 0);
    }
  }

  // returns a boolean that shows whether the transaction went through or not
  bool purchaseItem(String item, Player player) {
    int cost = master[item]?.price ?? -1;
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

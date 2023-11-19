import 'package:flutter/material.dart';
import 'player.dart';

/* STATE FOR SHOP - since shop is a pop-up display, no state is needed. keeping this for reference */
/*
class ShopPage {
  final Player player;

  ShopPage({required this.player});

  Future<void> displayShop(BuildContext context, Player player) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (var item in currentShopMap.entries)
                          if (itemAvailable(item.key, player))
                            ShopItem(
                              itemName: item.key,
                              itemPrice: costMap[item.key] ?? -1,
                              onPressed: () => purchaseItem(item.key, player),
                            ),
                      ],
                    ),
                    
                  );
                },
              ),
              // title: Text(''),
              // actions: [

              // ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 100,
          color: Colors.yellow,
        ),
      ),
    );
  }
  // _ShopPageState createState() => _ShopPageState();
} 
*/

class Shop {
  // master shop map of all possible items
  // KEY: Item name, VALUE: Unlock level
  static const Map<String, int> masterShopMap = {
    'Sword': 1,
    'Apple': 2,
    'Shield': 3,
    'Health Potion': 4,
    'Magic Wand': 5,
    'Helmet': 6,
    'Gold Sword': 7,
    'Bow': 8,
    'Mana Elixir': 9,
    'Diamond Sword': 10,
    'Platinum Shield': 11,
    'Enchanted Robe': 12,
    'Dagger': 13,
    'Crystal Ball': 14,
    'Steel Armor': 15,
    'Fire Staff': 16,
    'Elixir of Wisdom': 17,
    'Invisibility Cloak': 18,
    'Thunder Hammer': 19,
    'Phoenix Feather': 20,
    'Ice Blade': 21,
    'Dragon Scale Armor': 22,
    'Vortex Orb': 23,
    'Shadow Cloak': 24,
    'Mystic Bow': 25,
    'Amulet of Power': 26,
    'Celestial Staff': 27,
    'Titanium Shield': 28,
    'Dimensional Robes': 29,
    'Excalibur': 30,
  };

  // contains the prices of all items, with the name as the key
  // KEY: Item name, VALUE: Item cost
  static const Map<String, int> costMap = {
    'Sword': 10,
    'Apple': 20,
    'Shield': 5,
    'Health Potion': 15,
    'Magic Wand': 30,
    'Helmet': 25,
    'Gold Sword': 40,
    'Bow': 35,
    'Mana Elixir': 20,
    'Diamond Sword': 60,
    'Platinum Shield': 50,
    'Enchanted Robe': 45,
    'Dagger': 35,
    'Crystal Ball': 40,
    'Steel Armor': 45,
    'Fire Staff': 50,
    'Elixir of Wisdom': 55,
    'Invisibility Cloak': 60,
    'Thunder Hammer': 65,
    'Phoenix Feather': 70,
    'Ice Blade': 75,
    'Dragon Scale Armor': 80,
    'Vortex Orb': 85,
    'Shadow Cloak': 90,
    'Mystic Bow': 95,
    'Amulet of Power': 100,
    'Celestial Staff': 105,
    'Titanium Shield': 110,
    'Dimensional Robes': 115,
    'Excalibur': 120,
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
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    /*
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (var item in currentShopMap.entries)
                          if (itemAvailable(item.key, player))
                            ShopItem(
                              itemName: item.key,
                              itemPrice: costMap[item.key] ?? -1,
                              onPressed: () => purchaseItem(item.key, player),
                            ),
                      ],
                    ),
                    */
                  );
                },
              ),
              // title: Text(''),
              // actions: [

              // ],
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


// class _ShopPageState extends State<ShopPage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shop'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [ 
//             for (var entry in storeInventory.entries)
//               if (canPlayerPurchaseItem(entry.key))
//                 ShopItem(
//                   itemName: entry.key,
//                   itemPrice: getItemPrice(entry.key),
//                   onPressed: () => buyItem(entry.key),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }



//   void buyItem(String itemName) {
//     if (storeInventory.containsKey(itemName) && storeInventory[itemName]! > 0) {
//       if (canPlayerPurchaseItem(itemName)) {
//         int itemPrice = getItemPrice(itemName);

//         if (widget.player.currency.canAfford(itemPrice)) {
//           widget.player.currency.subtractGold(itemPrice);
//           givePurchasedItem(itemName);
//           storeInventory[itemName] = storeInventory[itemName]! - 1;
//         } else {
//           print('Not enough gold to buy the $itemName.');
//         }
//       } else {
//         print('Item $itemName is not available at your level.');
//       }
//     } else {
//       print('Sorry, $itemName is out of stock.');
//     }
//   }

//   void givePurchasedItem(String itemName) {
//     print('You obtained a $itemName!');
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('$itemName'),
//             Text('$itemPrice gold'),
//           ],
//         ),
//       ),
//     );
//   }
// }


/* NO LONGER NEEDED BUT NOT QUITE SURE */

  // int getItemPrice(String itemName) {
  //   return {
  //     'Sword': 10,
  //     'Apple': 5,
  //     'Shield': 15,
  //     'Health Potion': 8,
  //     'Magic Wand': 30,
  //     'Helmet': 25,
  //     'Gold Sword': 40,
  //     'Bow': 35,
  //     'Mana Elixir': 20,
  //     'Diamond Sword': 60,
  //     'Platinum Shield': 50,
  //     'Enchanted Robe': 45,
  //     'Dagger': 35,
  //     'Crystal Ball': 40,
  //     'Steel Armor': 45,
  //     'Fire Staff': 50,
  //     'Elixir of Wisdom': 55,
  //     'Invisibility Cloak': 60,
  //     'Thunder Hammer': 65,
  //     'Phoenix Feather': 70,
  //     'Ice Blade': 75,
  //     'Dragon Scale Armor': 80,
  //     'Vortex Orb': 85,
  //     'Shadow Cloak': 90,
  //     'Mystic Bow': 95,
  //     'Amulet of Power': 100,
  //     'Celestial Staff': 105,
  //     'Titanium Shield': 110,
  //     'Dimensional Robes': 115,
  //     'Excalibur': 120,
  //   }[itemName] ??
  //       0;
  // }
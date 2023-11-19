q//hello
class PlayerScreen extends StatelessWidget {
 final int attack;
 final int defense;
 final int hp;
 final int level;
 final String armor;
 final String weapon;
 final String pet;
 final String imageUrl;

 PlayerScreen({
   required this.attack,
   required this.defense,
   required this.hp,
   required this.level,
   required this.armor,
   required this.weapon,
   required this.pet,
   required this.imageUrl,
 });

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Player Stats'),
     ),
     body: SingleChildScrollView(
       child: Column(
         children: [
           Image.network(imageUrl),
           Text('Attack: $attack'),
           Text('Defense: $defense'),
           Text('HP: $hp'),
           Text('Level: $level'),
           Text('Armor: $armor'),
           Text('Weapon: $weapon'),
           Text('Pet: $pet'),
         ],
       ),
     ),
   );
 }
}

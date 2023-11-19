class Enemy {
    Task task;
    Image image;
    bool defeated;

    Enemy(this.task, this.image) {
        defeated = false;
    }

    Enemy(this.task) {
        defeated = false;
        int i = Random().nextInt(6);
        switch (i) {
            case 0:
                image = Image.asset('assets/test_dragon.jpg');
                break;
            case 1:
                image = Image.asset('assets/test_eagle.jpg');
                break;
            case 2:
                image = Image.asset('assets/test_goblin.jpg');
                break;
            case 3:
                image = Image.asset('assets/test_octupus.jpg');
                break;
            case 4:
                image = Image.asset('assets/test_serpent.jpg');
                break;
            case 5:
                image = Image.asset('assets/test_wolf.jpg');
                break;
        }
    }
}
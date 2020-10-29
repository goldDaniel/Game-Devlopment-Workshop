class Player
{  
    //the position of the player
    float x;
    float y;


    //values used to control player movement
    float maxSpeed = 300;
    float currentSpeed = 0;
    float movementAngle = 0;

    //size(in pixels) the player will be drawn with
    //this is also used for collision checks
    final float size = 64;

    boolean isAlive = true;

    Player()
    {
        x = width / 2;
        y = height / 2;
    } 

    Player(float x, float y)
    {
        this.x = x;
        this.y = y;
    }
}

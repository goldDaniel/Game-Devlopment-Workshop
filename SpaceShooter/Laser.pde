/*
    All the data we need to manage a laser
*/
class Laser
{
    //position data
    float x;
    float y;

    //movement data
    final float speed;
    final float angle;

    //used for collision checking
    final float size;

    Laser(float x, float y, float speed, float angle, float size)
    {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.angle = angle;
        this.size = size;
    }

    
}

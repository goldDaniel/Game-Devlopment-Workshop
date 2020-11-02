/**
    Holds the data that asteroids need to move around
*/
class Asteroid
{
    final PImage image;

    //position data
    float x;
    float y;
    
    //movement data
    final float speed;
    final float angle;

    final float size;
    
    //used for drawing a spinning asteroid
    final float rotationSpeed;
    float drawAngle;
    

    Asteroid(PImage image, float x, float y, float speed, float angle)
    {
        this.image = image;
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.angle = angle;

        drawAngle = angle;
        rotationSpeed = 0.2f + PI * random(-0.4f, 0.4f);

        size = random(32, 64);
    }
}

class Enemy 
{
    //enemy position
    float x;
    float y;

    //movement variables
    float angle;
    final float speed = 150;
    final float size = 48;    

    public Enemy(float x, float y, float angle)
    {
        this.x = x;
        this.y = y;
        this.angle = angle;
    }
}
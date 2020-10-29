/*
    This system is responsible for checking collisions between lasers
    and other entities in the world
*/
class LaserSystem
{
    //the image we will use to draw the laser
    private PImage laserImage;

    //all of the lasers
    private ArrayList<Laser> lasers;

    LaserSystem()
    {
        lasers = new ArrayList<Laser>();
        laserImage = loadImage("Assets/laser.png");
    }

    /*
        We use this so lasers can interact with other systems
    */
    ArrayList<Laser> getLasers()
    {
        return lasers;
    }

    void update(float dt)
    {
        //this list will hold all the lasers we wish to destroy because
        //they have moved off of the screen
        ArrayList<Laser> toDestroy = new ArrayList();

        for(int i = 0; i < lasers.size(); i++)
        {
            Laser laser = lasers.get(i);

            //move our laser
            laser.x += cos(laser.angle) * laser.speed * dt;
            laser.y += sin(laser.angle) * laser.speed * dt;

            //if the laser is offscreen, we will remove it from our laser list
            //to save on memory and processing
            float offscreenBuffer = 128;
            if(laser.x < -offscreenBuffer || laser.x > width + offscreenBuffer ||
               laser.y < -offscreenBuffer || laser.y > height + offscreenBuffer)
            {
                toDestroy.add(laser);
            } 
        }

        //remove our lasers from being active
        lasers.removeAll(toDestroy);
    }


    /*
        Loops through our lasers, and draws it at the
        appropriate position and rotation
    */
    void draw()
    {
        for(int i = 0; i < lasers.size(); i++)
        {
            Laser laser = lasers.get(i);

            pushMatrix();
            
            translate(laser.x, laser.y);
            rotate(laser.angle);
            
            float w = laserImage.width;
            float h = laserImage.height;
            image(laserImage, -w/2, -h/2, w, h);

            popMatrix();      
        }
    }
}

class AsteroidSystem
{
    //the list that holds all asteroids
    private ArrayList<Asteroid> asteroids;

    //we use this to manage all the information needed to spawn asteroids
    private AsteroidSpawningSystem spawningSystem;

    //the image we use to draw asteroids with
    private PImage image;
    
    AsteroidSystem()
    {
        asteroids = new ArrayList();

        spawningSystem = new AsteroidSpawningSystem(asteroids);

        image = loadImage("Assets/asteroid.png");
    }

    /*
        Gets our list of asteroids so we can use them inside other systems
    */
    ArrayList<Asteroid> getAsteroids()
    {
        return asteroids;
    }

    void update(float dt)
    {
        //does all calculations needed to randomly spawn asteroids
        spawningSystem.update(dt);


        //similar to lasers, once the asteroid is fully offscreen we want to remove it
        ArrayList<Asteroid> toDestroy = new ArrayList();

        //moves the asteroids
        for(Asteroid asteroid : asteroids)
        {
            //move each asteroid at its speed & angle
            asteroid.x += cos(asteroid.angle) * asteroid.speed * dt;
            asteroid.y += sin(asteroid.angle) * asteroid.speed * dt;

            //adjusts our animation angle
            asteroid.drawAngle += asteroid.rotationSpeed * dt;

            //if the asteroid is offscreen by a certain amount, remove it from our list
            float offscreenBuffer = asteroid.size*2;
            if(asteroid.x < -offscreenBuffer || asteroid.x > width + offscreenBuffer ||
               asteroid.y < -offscreenBuffer || asteroid.y > height + offscreenBuffer)
            {
                toDestroy.add(asteroid);
            } 
        }

        asteroids.removeAll(toDestroy);
    }

    /*
        Loops through all of our asteroids, and draws
        with the appropriate position, rotation, and scale
    */
    void draw()
    {
        for(Asteroid a : asteroids)
        {
            pushMatrix();

            translate(a.x, a.y);
            rotate(a.angle + a.drawAngle);
            
            image(image, -a.size/2, -a.size/2, a.size, a.size);

            popMatrix();    
        }
    }
}

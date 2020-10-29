/**
    This system creates asteroids in our world
*/
class AsteroidSpawningSystem
{
    //the images an asteroid can have
    ArrayList<PImage> asteroidImages;

    //the list of all asteroids in the world
    ArrayList<Asteroid> asteroids;

    //the time until we have a chance to spawn an asteroid
    final private float spawnTime = 0.75f;
    //our timer
    private float spawnTimer = spawnTime;
    //the chance of spawning an asteroid 
    private float spawnChance = 0.8f;

    AsteroidSpawningSystem(ArrayList<Asteroid> asteroids)
    {
        this.asteroids = asteroids;

        //load all of our asteroid images and add them to our list
        asteroidImages = new ArrayList();
        asteroidImages.add(loadImage("assets/asteroid0.png"));
        asteroidImages.add(loadImage("assets/asteroid1.png"));
        asteroidImages.add(loadImage("assets/asteroid2.png"));
        asteroidImages.add(loadImage("assets/asteroid3.png"));
    }

    void update(float dt)
    {
        spawnTimer -= dt;
        //every "spawnTime" seconds, we have a "spawnChance" chance
        //to create an asteroid
        if(spawnTimer <= 0)
        {
            //reset our timer
            spawnTimer = spawnTime;

            float randomVal = random(0.f, 1.f);
            if(randomVal < spawnChance)
            {
                spawnAsteroid();           
            }
        }        
    }

    /*
        This method will decide the position and speed of an asteroid
    */
    private void spawnAsteroid()
    {
        float x;
        float y;
        float angle;
        float speed = random(64.f, 128.f);

        //This determines which axis we will spawn our asteroid along
        boolean horizontalSpawning = random(0.f, 1.f) > 0.5f;

        //in this case we are spawning on the horizontal axis
        //the asteroid will either spawn from the left or the right
        if(horizontalSpawning)
        {
            //select our Y position
            y = random(height/4.f, height*3.f/4.f);
            
            
            // 50/50 chance of spawning on the left or right side
            boolean left = random(0.f, 1.f) > 0.5f;
            //if we are spawning on the left side, set the angle appropriately
            if(left)
            {
                x = 0;
                angle = random(-PI / 4, PI/4);
            }
            //if we are spawning on the right side, set the angle appropriately
            else 
            {
                x = width;
                angle = random(PI - PI / 4, PI + PI/4);
            }
        }
        //in this case we are spawning on the vertical axis
        //the asteroid will either spawn from the top or the bottom
        else
        {
            //select our X position
            x = random(width/4.f, width*3.f/4.f);
            
            // 50/50 chance of spawning on the top or bottom side
            boolean top = random(0.f, 1.f) > 0.5f;
            //if we are spawning from the top, set the angle appropriately
            if(top)
            {
                y = 0;
                angle = random(PI / 2.f - PI / 4.f, PI / 2.f + PI / 4.f);
            }
            //if we are spawning from the bottom, set the angle appropriately
            else 
            {
                y = height;
                angle = random(-PI/2.f - PI / 4.f, -PI/2.f + PI / 4.f);
            }
        }

        //get a random index to access our iamges
        int imageIndex = floor(random(0, asteroidImages.size()));
        
        //get the image we want the asteroid to appear as
        PImage image = asteroidImages.get(imageIndex);

        //create the asteroid and add it to our list
        Asteroid asteroid = new Asteroid(image, x, y, speed, angle);
        asteroids.add(asteroid);
    }
}

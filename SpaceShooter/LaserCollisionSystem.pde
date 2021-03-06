class LaserCollisionSystem
{
    private Game.Stats stats;

    private ArrayList<Laser> lasers;
    private ArrayList<Asteroid> asteroids;
    private ArrayList<Enemy> enemies;

    LaserCollisionSystem(ArrayList<Laser> lasers, ArrayList<Asteroid> asteroids, ArrayList<Enemy> enemies, Game.Stats stats)
    {
        this.lasers = lasers;
        this.asteroids = asteroids;
        this.enemies = enemies;
        this.stats = stats;
    }

    void checkCollisions()
    {
        ArrayList<Laser> removeLasers = new ArrayList();
        ArrayList<Asteroid> removeAsteroid = new ArrayList();
        ArrayList<Enemy> removeEnemies = new ArrayList();

        for(Laser laser : lasers)
        {
            for(Asteroid asteroid : asteroids)
            {
                //we are using circle collision detection, here are the steps.

                //1. Calculate the distance between the 2 objects
                // we do by using the formula for the distance between 2 points
                float distance = sqrt( (laser.x - asteroid.x)*(laser.x - asteroid.x) + (laser.y - asteroid.y)*(laser.y - asteroid.y));

                //2. Calculate how close the objects need to be to collide
                //Since we are dealing with circles, this value is the sum of their radii
                float threshold = laser.size + asteroid.size;

                //3. Compare the 2 values. if the distance is less than the threshold then we are colliding
                boolean colliding = distance < threshold;


                //if we are colliding, we want to remove the laser, and the asteroid from the world
                if(colliding)
                {
                    removeLasers.add(laser);
                    removeAsteroid.add(asteroid);

                    stats.score += 10;
                }
            }
            asteroids.removeAll(removeAsteroid);
            removeAsteroid.clear();

            
            //now we repeat for enemies
            for(Enemy enemy : enemies)
            {
                //we are using circle collision detection, here are the steps.

                //1. Calculate the distance between the 2 objects
                // we do by using the formula for the distance between 2 points
                float distance = sqrt( (laser.x - enemy.x)*(laser.x - enemy.x) + (laser.y - enemy.y)*(laser.y - enemy.y));

                //2. Calculate how close the objects need to be to collide
                //Since we are dealing with circles, this value is the sum of their radii
                float threshold = laser.size + enemy.size;

                //3. Compare the 2 values. if the distance is less than the threshold then we are colliding
                boolean colliding = distance < threshold;


                //if we are colliding, we want to remove the laser, and the asteroid from the world
                if(colliding)
                {
                    removeLasers.add(laser);
                    removeEnemies.add(enemy);

                    stats.score += 25;
                }
            }
            enemies.removeAll(removeEnemies);
            removeEnemies.clear();
        }
        lasers.removeAll(removeLasers);
        removeLasers.clear();
    }
}

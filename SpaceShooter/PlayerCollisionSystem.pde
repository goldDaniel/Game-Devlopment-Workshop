class PlayerCollisionSystem
{
    private Player player;

    private ArrayList<Asteroid> asteroids;
    private ArrayList<Enemy> enemies;

    private Game.Stats stats;

    PlayerCollisionSystem(Player player, ArrayList<Asteroid> asteroids, ArrayList<Enemy> enemies, Game.Stats stats)
    {
        this.player = player;
        this.asteroids = asteroids;
        this.enemies = enemies;
        this.stats = stats;
    }

    public void checkCollisions()
    {
        //we dont need to check for collisions if the player is dead
        if(!player.isAlive) return;

        
        for(Asteroid asteroid : asteroids)
        {
            //we are using circle collision detection, here are the steps.

            //1. Calculate the distance between the 2 objects
            // we do by using the formula for the distance between 2 points
            float distance = sqrt( (player.x - asteroid.x)*(player.x - asteroid.x) + (player.y - asteroid.y)*(player.y - asteroid.y));

            //2. Calculate how close the objects need to be to collide
            //Since we are dealing with circles, this value is the sum of their radii
            //NOTE: we use player.size/8 to give the player a smaller hitbox
            float threshold = player.size / 2 + asteroid.size / 2;

            //3. Compare the 2 values. if the distance is less than the threshold then we are colliding
            boolean colliding = distance < threshold;

            if(colliding)
            {   
                
                player.isAlive = false;
                
                //reset the player 
                player.x = width / 2;
                player.y = height / 2;
                player.currentSpeed = 0;

                //lowers our lives counter
                stats.lives -= 1;

                //as we are colliding, we are going to delete all the enemies asteroids 
                //on screen to give the player a moment to respawn
                asteroids.clear();
                enemies.clear();
                
                //since we are colliding, we no longer need to check for other collisions
                //so we can just exit the method
                return;
            }
        }

        //now we repeat with collisions for enemies
        for(Enemy enemy : enemies)
        {
            float distance = sqrt( (player.x - enemy.x)*(player.x - enemy.x) + (player.y - enemy.y)*(player.y - enemy.y));

            //2. Calculate how close the objects need to be to collide
            //Since we are dealing with circles, this value is the sum of their radii
            //NOTE: we use player.size/8 to give the player a smaller hitbox
            float threshold = player.size / 2 + enemy.size / 2;

            //3. Compare the 2 values. if the distance is less than the threshold then we are colliding
            boolean colliding = distance < threshold;

            if(colliding)
            {   
                
                player.isAlive = false;
                
                //reset the player 
                player.x = width / 2;
                player.y = height / 2;
                player.currentSpeed = 0;

                //lowers our lives counter
                stats.lives -= 1;

                //as we are colliding, we are going to delete all the enemies asteroids 
                //on screen to give the player a moment to respawn
                asteroids.clear();
                enemies.clear();
                
                //since we are colliding, we no longer need to check for other collisions
                //so we can just exit the method
                return;
            }
        }
    }
}
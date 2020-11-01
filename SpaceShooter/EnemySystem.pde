class EnemySystem
{
    //the image we use to draw enemies
    PImage image;
    
    //all enemies in the world
    ArrayList<Enemy> enemies;

    //we need a reference to the player, so the enemy can track it
    Player player;

    //the time it takes to spawn a new enemy
    final float spawnTime = 2.3f;
    float spawnTimer = spawnTime;

    /*
        creates the enemy system
        we need the player as a parameter, so the enemies can target it 
    */
    public EnemySystem(Player player)
    {
        this.player = player;
        enemies = new ArrayList();
        image = loadImage("Assets/enemyShip.png");
    }

    ArrayList<Enemy> getEnemies()
    {
        return enemies;
    }

    void update(float dt)
    {
        for(Enemy e : enemies)
        {
            e.x += cos(e.angle) * e.speed * dt;
            e.y += sin(e.angle) * e.speed * dt;

        
            //turn the positions into vectors and use the built in methods
            //to get the angle between the points
            PVector p0 = new PVector(player.x, player.y);
            PVector p1 = new PVector(e.x, e.y);
            //p0 is now our target vector
            p0.sub(p1).normalize();

            //now that we have our target vector we get the current direction vector
            PVector currentTarget = new PVector(cos(e.angle), sin(e.angle));

            PVector nextDir = PVector.lerp(currentTarget, p0, 2* dt);
            float finalAngle = nextDir.heading();

            e.angle = finalAngle;
        }

        spawnEnemies(dt);
    }

    void draw()
    {
        for(Enemy e : enemies)
        {
            pushMatrix();

            translate(e.x, e.y);
            rotate(e.angle);

            image(image, -e.size / 2, -e.size / 2, e.size, e.size);

            popMatrix();
        }
    }

    /*
        this will spawn an enemy from one of the edges of the screen
    */
    private void spawnEnemies(float dt)
    {
        spawnTimer -= dt;
        if(spawnTimer <= 0)
        {
            spawnTimer = spawnTime;

            float spawnX;
            float spawnY;

            //this gives us a 50/50 chance of spawning on the left vs right side
            boolean leftSide = random(0.f, 1.f) > 0.5f;
            if(leftSide)
            {
                spawnX = 0;
            } 
            else
            {
                spawnX = width;
            }   

            //this gives us a 50/50 chance of spawning on the top vs bottom side
            boolean topSide = random(0.f, 1.f) > 0.5f;
            if(topSide)
            {
                spawnY = 0;
            }  
            else
            {
                spawnY = height;
            }         

            //turn the positions into vectors and use the built in methods
            //to get the angle between the points
            PVector p0 = new PVector(player.x, player.y);
            PVector p1 = new PVector(spawnX, spawnY);
            float spawnAngle = p0.sub(p1).heading();

            Enemy nextEnemy = new Enemy(spawnX, spawnY, spawnAngle);
            enemies.add(nextEnemy);
        }
    }
}

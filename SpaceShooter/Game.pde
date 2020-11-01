import processing.sound.*;
/*
    This class is responsible for updating our game data, and systems
*/
class Game
{
    //This will hold any extra information we need for the game to run
    class Stats
    {
        public int score = 0;
        public int lives = 3;
    }
    private Stats stats;
  
    //the image representing our remaining lives
    private PImage lifeImage;
    
    //the sound we use when firing lasers
    private SoundFile laserSound;

    //used to manage all asteroids in the game
    private AsteroidSystem asteroidSystem;
    
    //used to manage the player
    private PlayerSystem playerSystem;

    //manages all enemy ships 
    private EnemySystem enemySystem;
    
    //used to manage all the lasers in the game
    private LaserSystem laserSystem;
    
    //manages collisions between lasers and asteroids
    private LaserCollisionSystem laserCollisions;
    
    //manages collisions between player and asteroids
    private PlayerCollisionSystem playerCollisions;
    
    //initializes all entities and systems needed to run the game
    Game()
    {
        stats = new Stats();
        
        lifeImage = loadImage("Assets/playerLife.png");

        //manages lasers
        laserSystem = new LaserSystem();

        //manages asteroids
        asteroidSystem = new AsteroidSystem();
        
        //the player system accepts a weapon as a parameter
        //this way we are able to switch the weapon type
        laserSound = loadSound("Assets/playerFire.mp3");
        Weapon defaultWeapon = new DefaultWeapon(laserSystem.getLasers(), laserSound);
        playerSystem = new PlayerSystem(defaultWeapon);

        //initializes our enemies system
        enemySystem = new EnemySystem(playerSystem.getPlayer());

        //handles collisions between lasers & asteroids
        laserCollisions = new LaserCollisionSystem(laserSystem.getLasers(), asteroidSystem.getAsteroids(), enemySystem.getEnemies(), stats);

        //handles collisions between the player & asteroids
        playerCollisions = new PlayerCollisionSystem(playerSystem.getPlayer(), asteroidSystem.getAsteroids(), enemySystem.getEnemies(), stats);
    }

    public boolean isGameOver()
    {
        return stats.lives == 0;
    }


    /*
        resets the game stats, allowing us to restart
    */
    public void resetStats()
    {
        stats.lives = 3;
        stats.score = 0;
    }

    public void update(float dt)
    {
        //no lives, then we do not update as the game is over
        //so we just exit the method
        if(stats.lives == 0) return;


        //if we are pushing 1, switch to the default weapon
        if(isKeyDown('1'))
        {
            Weapon nextWeapon = new DefaultWeapon(laserSystem.getLasers(), laserSound);
            playerSystem.setWeapon(nextWeapon);
        }
        //if we are pushing 2, switch to the machine laser weapon
        if(isKeyDown('2'))
        {
            Weapon nextWeapon = new MachineLaser(laserSystem.getLasers(), laserSound);
            playerSystem.setWeapon(nextWeapon);
        }
        //if we are pushing 3, switch to the shotgun laser weapon
        if(isKeyDown('3'))
        {
            Weapon nextWeapon = new ShotgunLaser(laserSystem.getLasers(), laserSound);
            playerSystem.setWeapon(nextWeapon);
        }


        //updates player info
        playerSystem.update(dt);
        
        //updates asteroid info
        asteroidSystem.update(dt);

        //updates enemy info
        enemySystem.update(dt);

        //updates laser info
        laserSystem.update(dt);

        //checks for collisions between lasers and asteroids
        laserCollisions.checkCollisions();

        playerCollisions.checkCollisions();
    }

    public void draw()
    {
        if(stats.lives == 0)
        {
            //changes text color to white
            fill(color(255,255,255));
            //sets text size
            textSize(64);
            //the origin of our text will be the CENTER
            textAlign(CENTER,CENTER);
            //draws the text with our settings
            text("GAME OVER", width/2, height/2);
            
            textSize(32);
            text("FINAL SCORE: " + stats.score, width/2, height/2 + 72);
        }

        //draws all asteroids
        asteroidSystem.draw();

        //draws all enemies
        enemySystem.draw();

        //draws all lasers
        laserSystem.draw();
        
        //draws the player
        playerSystem.draw();

                
        drawUI();
    }

    private void drawUI()
    {
        //draws our SCORE info 
        //changes text color to white
        fill(color(255,255,255));
        //sets text size to 32
        textSize(32);
        //the origin of our text will be the top-left corner
        textAlign(LEFT,TOP);
        //draws the text with our settings
        text("SCORE: " + stats.score, 0, 0);


        //draws our LIVES info
        text("LIVES: ", 0, 32);
        for(int i = 0; i < stats.lives; i++)
        {
            image(lifeImage, 100 + i * (lifeImage.width + 2), 16 + lifeImage.height, lifeImage.width, lifeImage.height);
        }


        //draws our firing cooldown bar
        //with no outline
        noStroke();
        //set the color to green
        fill(color(128, 255, 128));
        //get the percent of the bar that will be filled
        float fillPercent = playerSystem.getWeapon().getCooldownPercent();
        //draws the bar
        rect(0, 68, 150 * fillPercent, 8);

        //draws the outline of the rectangle, this way we can see how full the bar is 
        stroke(color(255,255,255));
        noFill();
        rect(0, 68, 150, 8);
    }

    
}

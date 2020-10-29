/*
    This system is responsible for the player
*/
class PlayerSystem
{
    //the image of the player
    private PImage image;

    //the player that this sytem controls
    private Player player;

    //the weapon we are currently using
    private Weapon weapon;

    //after the player dies, it takes this amount of seconds to respawn
    private final float respawnTime = 1.f;
    private float respawnTimer = respawnTime;

    public PlayerSystem(Weapon weapon)
    {
        player = new Player();
        this.weapon = weapon;
        image = loadImage("Assets/playerShip.png");
    }

    /*
        gets the player so it can interact with other systems
    */
    public Player getPlayer()
    {
        return player;
    }

    public Weapon getWeapon()
    {
        return weapon;
    }

    /*
        changes the weapon we are currently using
    */
    public void setWeapon(Weapon weapon)
    {
        this.weapon = weapon;
    }

    /*
        does the logic for player interactions
    */
    public void update(float dt)
    {
        //update the player if it is alive, if the player is not alive
        //then we will activate the respawn timer
        if(player.isAlive)
        {
            doPlayerMovement(dt);
            doPlayerShooting(dt);
        }
        else 
        {
            //counts down our timer
            respawnTimer -= dt;

            //the timer is done now, so we set the player back to 
            //alive and then reset the timer
            if(respawnTimer <= 0)
            {
                player.isAlive = true;
                respawnTimer = respawnTime;
            }
        }
    }

    /*
        draws the player to the screen
    */
    public void draw()
    {
        //if the player is dead we do not want to draw
        //so we just exit the method 
        if(!player.isAlive) return;

        pushMatrix();


        translate(player.x, player.y);
        rotate(player.movementAngle);


        image(  image, 
                -player.size / 2,-player.size / 2, 
                player.size, player.size);

        popMatrix();
    }


    /*
        This method will check for input and move the player around
        the level
    */
    private void doPlayerMovement(float dt)
    {
        //if we press this key, we will accelerate the player
        //the speed is also clamped within here
        if(isKeyDown('w'))
        {
            float acceleration = player.maxSpeed;
            player.currentSpeed += acceleration * dt;

            if(player.currentSpeed > player.maxSpeed)
            {
                player.currentSpeed = player.maxSpeed;
            }
        }

        //if we press this key, we decelerate the player
        //the speed is clamped to 0 within as well
        if(isKeyDown('s'))
        {
            float deceleration = player.maxSpeed * 2.f;
            player.currentSpeed -= deceleration * dt;

            if(player.currentSpeed < 0)
            {
                player.currentSpeed = 0;
            } 
        }
        
        //rotate the player when these keys are pressed
        if(isKeyDown('a'))
        {
            player.movementAngle -= PI * dt;
        }
        if(isKeyDown('d'))
        {
            player.movementAngle += PI * dt;
        }
        
        //updates the player position
        player.x += cos(player.movementAngle) * player.currentSpeed * dt;
        player.y += sin(player.movementAngle) * player.currentSpeed * dt;

        //teleports player from the left side to the right,
        //and from the right side to the left
        //this gives the illusion of a wrapping-around world
        if(player.x > width)
        {
            player.x = 0;
        }
        if(player.x < 0)
        {
            player.x = width;
        }

        //teleports player from the top side to the bottom,
        //and from the bottom side to the top
        //this gives the illusion of a wrapping-around world
        if(player.y > height)
        {
            player.y = 0;
        }
        if(player.y < 0)
        {
            player.y = height;
        }
    }

    /*
        Checks if we are pressing the mouse button and fires the weapon
    */
    private void doPlayerShooting(float dt)
    {
        //this will update the cooldown timer of the weapon
        weapon.update(dt);

        //shoot a laser if we are presssing the left mouse button
        if(mousePressed)
        {
            if(mouseButton == LEFT)
            {
                //gets the angle between the mouse and the player
                PVector p0 = new PVector(player.x, player.y);
                PVector p1 = new PVector(mouseX, mouseY);
                float angle = p1.sub(p0).heading();

                weapon.fire(player.x, player.y, player.size, angle);
            }
        }
    }
}

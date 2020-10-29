abstract class Weapon
{
    ArrayList<Laser> lasers; 

    //values used to control player shooting
    float fireTimer;
    float fireRate;

    //how fast the laser fired will move
    float laserSpeed;
    float collisionSize;

    public Weapon(ArrayList<Laser> lasers)
    {
        this.lasers = lasers;
    }

    final float getCooldownPercent()
    {
        return 1.f - (fireTimer / fireRate);
    }

    final void update(float dt)
    {
        //counts down the timer, this way we only fire at the firerate
        fireTimer -= dt;
        if(fireTimer < 0) fireTimer = 0;
    }

    abstract void fire(float x, float y, float offset, float angle);
}


/*
    The default weapon fires 2 laser bolts parallel to each other
*/
class DefaultWeapon extends Weapon
{

    //here we will set the parameters for the weapon
    public DefaultWeapon(ArrayList<Laser> lasers)
    {
        super(lasers);

        fireRate = 0.4f;
        laserSpeed = 1200.f;
        collisionSize = 32;

        fireTimer = fireRate;
    }

    void fire(float x, float y, float offset, float angle)
    {
        //if our fire cooldown has passed, create a new bullet
        if(fireTimer <= 0)
        {
            fireTimer = fireRate;            

            //we need the angle tangent to the angle we are shooting at
            //using this angle, we can offset the lasers such that they are parallel            
            //we set the laser position, and then move it along the tangent angle 
            float tangentAngle = angle + PI/2.0;

            //how far apart our parallel lasers will be 
            float laserSpacing = 8;

            //Note that in this case we offset in the positive direction
            float laserX = x + cos(angle) * offset + cos(tangentAngle) * laserSpacing;
            float laserY = y + sin(angle) * offset + sin(tangentAngle) * laserSpacing;
            Laser laser = new Laser(laserX, laserY, 
                                    laserSpeed, 
                                    angle, 
                                    collisionSize);
            lasers.add(laser);
            
            //Note that in this case we offset in the negative direction
            laserX = x + cos(angle) * offset - cos(tangentAngle) * laserSpacing;
            laserY = y + sin(angle) * offset - sin(tangentAngle) * laserSpacing;
            laser = new Laser(laserX, laserY, 
                              laserSpeed, 
                              angle,
                              collisionSize);
            lasers.add(laser);
        }
    }
}

/*
    This weapon fires very quickly, but also is very inaccurate
*/
class MachineLaser extends Weapon
{
    MachineLaser(ArrayList<Laser> lasers)
    {
        super(lasers);

        fireRate = 0.2f;
        laserSpeed = 1400.f;
        collisionSize = 16;

        fireTimer = fireRate;
    }

    void fire(float x, float y, float offset, float angle)
    {
        //if our fire cooldown has passed, create a new bullet
        if(fireTimer <= 0)
        {
            fireTimer = fireRate;            

            //set the laser spawn position
            float laserX = x + cos(angle) * offset / 2;
            float laserY = y + sin(angle) * offset / 2;

            //as we want our weapon to be inaccurate, we add a random
            //offset angle to the firing direction
            angle += random(-PI/12, PI/12);
            Laser laser = new Laser(laserX, laserY, 
                                    laserSpeed, 
                                    angle, 
                                    collisionSize);
            lasers.add(laser);
        }
    }
}

/*
    This weapon fires slowly, but has a large spread of lasers
*/
class ShotgunLaser extends Weapon
{
    ShotgunLaser(ArrayList<Laser> lasers)
    {
        super(lasers);

        fireRate = 1.f;
        laserSpeed = 1400.f;
        collisionSize = 8;

        fireTimer = fireRate;
    }

    void fire(float x, float y, float offset, float angle)
    {
        //if our fire cooldown has passed, create a new bullet
        if(fireTimer <= 0)
        {
            fireTimer = fireRate;            

            //set the laser spawn position
            float laserX = x + cos(angle) * offset / 2;
            float laserY = y + sin(angle) * offset / 2;


            int numLasers = 8;
            float maxSpread = PI / 6;
            for(int i = 0; i < numLasers; i++)
            {   
                //we based on the amount of lasers, we step between our spread range
                //so we can add to our firing angle, this gives us the arc of bullets
                float lerpVal = (float)i / (float)numLasers;
                float fireAngle = angle + lerp(-maxSpread, maxSpread, lerpVal);    
                
                //as we want our weapon to be inaccurate, we add a random
                //offset angle to the firing direction    
                angle += random(-PI/16, PI/16);
                Laser laser = new Laser(laserX, laserY, 
                                        laserSpeed, 
                                        fireAngle, 
                                        collisionSize);
                lasers.add(laser);
            }
        }
    }
}
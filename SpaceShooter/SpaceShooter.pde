//This file is the entry point to our game
//here we will do some boilerplate code needed
//to get our program running. The majority of the game
//will be done within the "Game" class

//NOTE:
//Keep in mind that all variables at the top of this file
//are global and can be accesed by anything, anywhere in the program


//The game that is the heart of our program
Game game;

//the previous time in milliseconds, used to calculate deltatime
float previousTimeMillis;

//which keys are currently being held
HashMap<Integer, Boolean> inputMap;

//the image for the background
private PImage background;

//the image for the cursor
private PImage reticle;

boolean gameStarted = false;

//used to reset the game at the end;
final float gameOverTime = 5.f;
float gameOverTimer = gameOverTime;


//This method gets called when the program starts.
//you can think of it as our "Main" method
void setup()
{
    //sets the screen size
    //for certain reasons, we cannot set this with variables,
    //it must be hard-coded values. We can access these values
    //using the built in "width" and "height" variables
    size(1280, 720);
    //We do not want to draw the mouse in our window, we are
    //using a custom cursor instead
    noCursor();

    //stores input state
    inputMap = new HashMap();

    //set the time in milliseconds
    previousTimeMillis = millis();    
    
    
    //creates the background image and sets the size to match the screen
    background = loadImage("Assets/spaceBackground.png");
    background.resize(width, height);

    //the image for our aiming cursor
    reticle = loadImage("Assets/reticle.png");
    
    //create our game
    game = new Game();
}

//processing will call this method approximately 60 times per second
//this is like the heartbeat of our program, and will update/draw everything
void draw()
{  
    //get the current time
    float currentTimeMillis = millis();
    //calculate the difference in frame time
    float deltaTime = currentTimeMillis - previousTimeMillis;
    //we divide by 1000 to convert the units from "milliseconds" to "seconds"
    deltaTime /= 1000.0;
    //the previous time next frame will be the current time this frame
    previousTimeMillis = currentTimeMillis;


    if(game.isGameOver())
    {
        gameOverTimer -= deltaTime;
        if(gameOverTimer <= 0)
        {
            gameOverTimer = gameOverTime;
            game.resetStats();

            gameStarted = false;
        }
    }


    clear();
    image(background, 0, 0);

    //if we have clicked "start game" then we will run the game
    //otherwise we will do main menu interactions
    if(gameStarted)
    {
        //updates game logic
        game.update(deltaTime);

        //draws game to screen
        game.draw();
    }
    else
    {
        mainMenu();
    }
    drawMouseCursor();
}

void mainMenu()
{

    //draws the title 
    textSize(128);
    textAlign(CENTER,CENTER);
    fill(color(255,255,255));
    text("Asteroid Blaster", width/2, 64);

    
    //draws our main-menu options
    float textSize = 64;
    textSize(textSize);

    //the location for the text
    float textX = width / 2;
    float textY = height / 2;
    //these are used to check if the mouse is over the button
    float btnWidth = textWidth("Play");
    float btnHeight = textSize + 1;
    float btnX = textX - btnWidth / 2;
    float btnY = textY - btnHeight / 2 + textDescent();

    //which color we will use to draw the text
    color colorToUse;   
    
    //this checks if the mouse cursor is in the box around the text
    if(mouseX > btnX && mouseX < btnX + btnWidth &&
       mouseY > btnY && mouseY < btnY + btnHeight)
    {
        //if we are pressing the left-mouse button while inside the
        //box around the text, then we start the game
        if(mousePressed)
        {
            if(mouseButton == LEFT)
            {
                gameStarted = true;
            }
        }

        //we are in the box, change the color
        colorToUse = color(200, 100, 200);
    }
    else
    {
        //we are not in the box, draw white text
        colorToUse = color(255,255,255);
    }
    fill(colorToUse);
    text("Play", textX, textY);

    //the location for the text
    textX = width / 2;
    textY = height / 2 + 128;
    //these are used to check if the mouse is over the button
    btnWidth = textWidth("Quit");
    btnHeight = textSize + 1;
    btnX = textX - btnWidth / 2;
    btnY = textY - btnHeight / 2 + textDescent();

    //this checks if the mouse cursor is in the box around the text
    if(mouseX > btnX && mouseX < btnX + btnWidth &&
       mouseY > btnY && mouseY < btnY + btnHeight)
    {
        //if we are pressing the left-mouse button while inside the 
        //box around the text, then we exit the program
        if(mousePressed)
        {
            if(mouseButton == LEFT)
            {
                exit();
            }
        }

        //we are in the box, change the colors
        colorToUse = color(200, 100, 200);
    }
    else
    {
        //we are not in the box, use white color for text
        colorToUse = color(255,255,255);
    }
    fill(colorToUse);
    text("Quit", textX, textY);
}

private void drawMouseCursor()
{
    //draws our aiming cursor
    pushMatrix();
    translate(mouseX, mouseY);
    float mouseSize = 48;
    image(reticle, -mouseSize/2, -mouseSize/2, mouseSize, mouseSize);
    popMatrix();
}


//This is the method we will call when checking if we have pressed a key 
boolean isKeyDown(char key)
{
    char pressed = Character.toLowerCase(key);
    if(inputMap.containsKey((int)pressed))
    {
        return inputMap.get((int)pressed);
    }

    return false;
}


void keyPressed()
{
    char pressed = Character.toLowerCase(key);
    inputMap.put((int)pressed, true);   
}


void keyReleased()
{
    char pressed = Character.toLowerCase(key);
    inputMap.put((int)pressed, false);
}

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

int soilTimer=0;
int soilDuration = 15;
int stone0Duration = 30;
int stone1Duration = 45;

boolean demoMode = false;

void setup() {
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	groundhogIdle = loadImage("img/groundhogIdle.png");
	groundhogLeft = loadImage("img/groundhogLeft.png");
	groundhogRight = loadImage("img/groundhogRight.png");
	groundhogDown = loadImage("img/groundhogDown.png");
	life = loadImage("img/life.png");
	soldier = loadImage("img/soldier.png");
	cabbage = loadImage("img/cabbage.png");

	soilEmpty = loadImage("img/soils/soilEmpty.png");

	// Load soil images used in assign3 if you don't plan to finish requirement #6
	soil0 = loadImage("img/soil0.png");
	soil1 = loadImage("img/soil1.png");
	soil2 = loadImage("img/soil2.png");
	soil3 = loadImage("img/soil3.png");
	soil4 = loadImage("img/soil4.png");
	soil5 = loadImage("img/soil5.png");

	// Load PImage[][] soils
	soils = new PImage[6][5];
	for(int i = 0; i < soils.length; i++){
		for(int j = 0; j < soils[i].length; j++){
			soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
		}
	}

	// Load PImage[][] stones
	stones = new PImage[2][5];
	for(int i = 0; i < stones.length; i++){
		for(int j = 0; j < stones[i].length; j++){
			stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
		}
	}

	//player
	playerX = PLAYER_INIT_X;
	playerY = PLAYER_INIT_Y;
	playerCol = (int) (playerX / SOIL_SIZE);
	playerRow = (int) (playerY / SOIL_SIZE);
	playerMoveTimer = 0;
	playerHealth = 2;

	// soil
	soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
	for(int i = 0; i < soilHealth.length; i++){
		for (int j = 0; j < soilHealth[i].length; j++) {
			 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones 
			soilHealth[i][j] = 15;
      if(i==j){soilHealth[i][j] = 30;}
      if(i==1 || i==2 || i==5 || i==6){if(j==8 || j==11 || j==12 || j==15) soilHealth[i][j] = 30;}
      if(i==0 || i==3 || i==4 || i==7){if(j==9 || j==10 || j==13 || j==14) soilHealth[i][j] = 30;}      
      if(j==16 || j==19 || j==22){
        if(i==1 || i==4 || i==7){soilHealth[i][j] = 30;}
        if(i==2 || i==5) {soilHealth[i][j] = 45;}
      }
      if(j==17 || j==20 || j==23){
        if(i==0 || i==3 || i==6) {soilHealth[i][j] = 30;}
        if(i==1 || i==4 || i==7) {soilHealth[i][j] = 45;}
      }
       if(j==18 || j==21 ){
        if(i==2 || i==5) {soilHealth[i][j] = 30;}
        if(i==0 || i==3 || i==6) {soilHealth[i][j] = 45;}
      }
		}
	}
      for(int f=1;f<24;f++){
        int empty= floor(random(1,3));
      for(int k=0;k<empty;k++){
         int x= floor(random(0,8));
          soilHealth[x][f] = 0;
          }
        }
	//soidiers
  soldierX = new float[6];
  soldierY = new float[6];
  for(int i=0; i<6; i++){
    float col = random(0,8);
    int row = floor(random(0,4))+i*4;
    soldierX[i] = col*80;
    soldierY[i] = row*80;
  }
	//cabbages
  cabbageX = new float[6];
  cabbageY = new float[6];  
  for(int i=0;i<6;i++){
    int col = floor(random(0,8));
    int row = floor(random(0,4))+i*4;
    cabbageX[i] = col*80;
    cabbageY[i] = row*80;
  }
}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}

		break;

		case GAME_RUN: // In-Game
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil

		for(int i = 0; i < soilHealth.length; i++){
			for (int j = 0; j < soilHealth[i].length; j++) {

				// Change this part to show soil and stone images based on soilHealth value
				// NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
				int areaIndex = floor(j / 4);
				image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);

				if(soilHealth[i][j] == 0){
        image(soilEmpty,i * SOIL_SIZE, j * SOIL_SIZE); 
        }

        if(soilHealth[i][j]>12&&soilHealth[i][j]<46) {
        image(soils[areaIndex][4],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j]>9&&soilHealth[i][j]<13) {
        image(soils[areaIndex][3],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j]>6 && soilHealth[i][j]<10) {
        image(soils[areaIndex][2],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j]>3&& soilHealth[i][j]<7) {
        image(soils[areaIndex][1],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j]>0&& soilHealth[i][j]<4) {
        image(soils[areaIndex][0],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        
        
        if(soilHealth[i][j] == 30){
          image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] == 45){
          image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);
          image(stones[1][4],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >27&&soilHealth[i][j] <46) {
          image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >24&&soilHealth[i][j] <28) {
          image(stones[0][3],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >21&&soilHealth[i][j] <25) {
          image(stones[0][2],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >18&&soilHealth[i][j] <22) {
          image(stones[0][1],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >15&&soilHealth[i][j] <19) {
          image(stones[0][0],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >42&& soilHealth[i][j] <46) {
          image(stones[1][4],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >39&& soilHealth[i][j] <43) {
          image(stones[1][3],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >36&& soilHealth[i][j] <40) {
          image(stones[1][2],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >33&& soilHealth[i][j] <37) {
          image(stones[1][1],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        if(soilHealth[i][j] >30&& soilHealth[i][j] <34) {
          image(stones[1][0],i * SOIL_SIZE,j * SOIL_SIZE);  
        }
			}
		}
		// Cabbages
    for(int i=0; i<6;i++){
      image(cabbage, cabbageX[i],cabbageY[i]);
      if(playerX<cabbageX[i]+80 && playerX+80>cabbageX[i] &&
         playerY<cabbageY[i]+80 && playerY+80>cabbageY[i]){
           if(playerHealth < 5){
            cabbageY[i] = 10000;
            playerHealth +=1;
           }
       }
    }
    // Soldiers
    for(int i=0; i<6;i++){
      image(soldier, soldierX[i],soldierY[i]);
      soldierX[i] += 2;
      if(soldierX[i] >= 640) soldierX[i] = -SOIL_SIZE;
      if(playerX<soldierX[i]+SOIL_SIZE && playerX+SOIL_SIZE>soldierX[i] &&playerY<soldierY[i]+SOIL_SIZE && playerY+SOIL_SIZE>soldierY[i]){
            playerHealth -=1 ;
            playerMoveTimer = 0;
            soilTimer = 0;
            playerX = PLAYER_INIT_X;
            playerY = PLAYER_INIT_Y;
            playerCol = (int) (playerX / SOIL_SIZE);
            playerRow = (int) (playerY / SOIL_SIZE);
            soilHealth[playerCol][playerRow+1] = 15;      
       }
    }    
		// Groundhog
    PImage groundhogDisplay = groundhogIdle;
    if(playerMoveTimer == 0){  
      if(playerRow<23&&soilHealth[playerCol][playerRow+1]==0){
        playerMoveDirection = DOWN;
        playerMoveTimer = playerMoveDuration;
      }
      else{
        if(leftState){
  
          groundhogDisplay = groundhogLeft;
  
          // Check left boundary
          if(playerCol > 0){
            if(playerRow>=0 && soilHealth[playerCol-1][playerRow] > 0){
              if(soilHealth[playerCol-1][playerRow] <16){
                soilTimer = soilDuration;
              }
              if(soilHealth[playerCol-1][playerRow] <31&&soilHealth[playerCol-1][playerRow] > 15) {
                soilTimer = stone0Duration;
              }
              if(soilHealth[playerCol-1][playerRow] <46&&soilHealth[playerCol-1][playerRow] > 30){
                soilTimer = stone1Duration;
              }
            }
            else{
            playerMoveDirection = LEFT;
            playerMoveTimer = playerMoveDuration;
            }
          }
  
        }else if(rightState){
  
          groundhogDisplay = groundhogRight;
  
          // Check right boundary
          if(playerCol < SOIL_COL_COUNT - 1){
           if(playerRow>=0 && soilHealth[playerCol+1][playerRow] > 0){
              if(soilHealth[playerCol+1][playerRow] <16){
                soilTimer = soilDuration;
              }
              if(soilHealth[playerCol+1][playerRow] <31&&soilHealth[playerCol+1][playerRow] > 15){
                soilTimer = stone0Duration;
              }
              if(soilHealth[playerCol+1][playerRow] <46&&soilHealth[playerCol+1][playerRow] > 30) {
                soilTimer = stone1Duration;
              }
            }
            else{
            playerMoveDirection = RIGHT;
            playerMoveTimer = playerMoveDuration;
            }
          }
  
        }else if(downState){
  
          groundhogDisplay = groundhogDown;
  
          // Check bottom boundary
          if(playerRow < SOIL_ROW_COUNT - 1){
             if(soilHealth[playerCol][playerRow+1] > 0){
              if(soilHealth[playerCol][playerRow+1] <16){
                soilTimer = soilDuration;
              }
              if(soilHealth[playerCol][playerRow+1] <31 &&soilHealth[playerCol][playerRow+1] > 15) {
                soilTimer = stone0Duration;
              }
              if(soilHealth[playerCol][playerRow+1] <46&&soilHealth[playerCol][playerRow+1] > 30) {
                soilTimer = stone1Duration;
              }
            }
          }
        }
      }
    }
    if(playerMoveTimer > 0){
      playerMoveTimer --;
      switch(playerMoveDirection){

        case LEFT:
        groundhogDisplay = groundhogLeft;
        if(playerMoveTimer == 0){
          playerCol--;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
        }
        break;

        case RIGHT:
        groundhogDisplay = groundhogRight;
        if(playerMoveTimer == 0){
          playerCol++;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
        }
        break;

        case DOWN:
        groundhogDisplay = groundhogDown;
        if(playerMoveTimer == 0){
          playerRow++;
          playerY = SOIL_SIZE * playerRow;
        }else{
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        }
        break;
      }

    }

    image(groundhogDisplay, playerX, playerY);
    

    if(soilTimer > 0){
      soilTimer -=1 ;      
      if(leftState){
        if(playerCol>=0 && playerRow>=0){
          soilHealth[playerCol-1][playerRow] -=1 ;
          if(soilHealth[playerCol-1][playerRow] <= 0){
            soilHealth[playerCol-1][playerRow] = 0 ;
          }
        }
      }
      if(rightState){
        if(playerCol<7 && playerRow>=0){
          soilHealth[playerCol+1][playerRow] -=1;
          if(soilHealth[playerCol+1][playerRow] <= 0){
            soilHealth[playerCol+1][playerRow] = 0 ;
          }
        }
      }
      if(downState){
        if(playerRow<23){
          soilHealth[playerCol][playerRow+1] -=1 ;
          if(soilHealth[playerCol][playerRow+1] <= 0){
            soilHealth[playerCol][playerRow+1] = 0 ;
          }
        }
      }
    }
		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// life
    for(int i=0; i<playerHealth; i++){
      image(life,10+i*70, 10);
      if(playerHealth >4){
        playerHealth = 5;
      }
    }  
    if(playerHealth == 0){
      gameState = GAME_OVER;
    }
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;

				// Initialize player
				playerX = PLAYER_INIT_X;
				playerY = PLAYER_INIT_Y;
				playerCol = (int) (playerX / SOIL_SIZE);
				playerRow = (int) (playerY / SOIL_SIZE);
				playerMoveTimer = 0;
				playerHealth = 2;

				//soil
				soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
				for(int i = 0; i < soilHealth.length; i++){
					for (int j = 0; j < soilHealth[i].length; j++) {
						 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
						soilHealth[i][j] = 15;
            if(i==j)soilHealth[i][j] = 30;
            if(i==1 || i==2 || i==5 || i==6){
              if(j==8 || j==11 || j==12 || j==15) soilHealth[i][j] = 30;
            }
            if(i==0 || i==3 || i==4 || i==7){
              if(j==9 || j==10 || j==13 || j==14) soilHealth[i][j] = 30;
            }      
            if(j==16 || j==19 || j==22){
              if(i==1 || i==4 || i==7) soilHealth[i][j] = 30;
              if(i==2 || i==5) soilHealth[i][j] = 45;
            }
            if(j==17 || j==20 || j==23){
              if(i==0 || i==3 || i==6) soilHealth[i][j] = 30;
              if(i==1 || i==4 || i==7) soilHealth[i][j] = 45;
            }
             if(j==18 || j==21 ){
              if(i==2 || i==5) soilHealth[i][j] = 30;
              if(i==0 || i==3 || i==6) soilHealth[i][j] = 45;
            }
					}
				}
        for(int f=1;f<24;f++){
          int empty= floor(random(1,3));
        for(int k=0;k<empty;k++){
           int x= floor(random(0,8));
            soilHealth[x][f] = 0;
            }
          }
            //soidiers
            soldierX = new float[6];
            soldierY = new float[6];
            for(int i=0; i<6; i++){
              float col = random(0,8);
              int row = floor(random(0,4))+i*4;
              soldierX[i] = col*80;
              soldierY[i] = row*80;
            }
          
            //cabbages
            cabbageX = new float[6];
            cabbageY = new float[6];  
            for(int i=0;i<6;i++){
              int col = floor(random(0,8));
              int row = floor(random(0,4))+i*4;
              cabbageX[i] = col*80;
              cabbageY[i] = row*80;
            }
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = true;
			break;
			case RIGHT:
			rightState = true;
			break;
			case DOWN:
			downState = true;
			break;
		}
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = false;
			break;
			case RIGHT:
			rightState = false;
			break;
			case DOWN:
			downState = false;
			break;
		}
	}
}

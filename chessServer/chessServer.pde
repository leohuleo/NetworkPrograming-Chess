import processing.net.*;

Server myServer;
//server = black, client = white

color lightbrown = #FFFFC3;
color darkbrown = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick, clickable;
int row1, col1, row2, col2;
int gridSize = 100;
boolean valid[][] = new boolean[8][8];

char grid[][] = {
  {'R','B','N','Q','K','N','B','R'},
  {'P','P','P','P','P','P','P','P'},
  {' ',' ',' ',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ',' ',' ',' '},
  {'p','p','p','p','p','p','p','p'},
  {'r','b','n','q','k','n','b','r'},
};

void setup(){
  size(800,800);
  for(int i = 0;i<8;i++){
    for(int j = 0;j<8;j++){
      valid[i][j] = false;
    }
  }
  myServer = new Server(this, 1234);
  clickable = true;
  firstClick = true;
  row1 = -1;
  row2 = -1;
  col1 = -1;
  col2 = -1;
  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");
  
  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw(){
  drawBoard();
  highlight();
  drawPieces();
  receiveMove();
}

void highlight(){
  if(row1 > 0 && col1 > 0){
    strokeWeight(10);
    stroke(0);
    noFill();
    rect(col1*gridSize,row1*gridSize, gridSize, gridSize);
    for(int i = 0;i<8;i++){
    for(int j = 0;j<8;j++){
      valid[i][j] = false;
    }
  }
    switch(grid[row1][col1]) {
    case 'R':
      rHighlight();
      break;
    case 'B':
      bHighlight();
      break;
    case 'N':
      nHighlight();
      break;
    case 'Q':
      qHighlight();
      break;
    case 'K':
      kHighlight();
      break;
    case 'P':
      pHighlight();
      break;
    }
  }
}

void rHighlight() {
  //all rows to the left
  for (int i = row1 - 1; i>=0; i--) {
    if (grid[i][col1] != ' ') {
      if (Character.isLowerCase(grid[i][col1])) {
        rect(col1*gridSize, i*gridSize, gridSize, gridSize);
        valid[i][col1] = true;
      }
      break;
    } else {
      rect(col1*gridSize, i*gridSize, gridSize, gridSize);
      valid[i][col1] = true;
    }
  }
  //all rows to the right
  for (int i = row1 + 1; i<8; i++) {
    if (grid[i][col1] != ' ') {
      if (Character.isLowerCase(grid[i][col1])) {
        rect(col1*gridSize, i*gridSize, gridSize, gridSize);
        valid[i][col1] = true;
      }
      break;
    } else {
      rect(col1*gridSize, i*gridSize, gridSize, gridSize);
      valid[i][col1] = true;
    }
  }
  //all columns above
  for (int i = col1 - 1; i>=0; i--) {
    if (grid[row1][i] != ' ') {
      if (Character.isLowerCase(grid[row1][i])) {
        rect(i*gridSize, row1*gridSize, gridSize, gridSize);
        valid[row1][i] = true;
      }
      break;
    } else {
      rect(i*gridSize, row1*gridSize, gridSize, gridSize);
      valid[row1][i] = true;
    }
  }
  //all columns below
  for (int i = col1 + 1; i<8; i++) {
    if (grid[row1][i] != ' ') {
      if (Character.isLowerCase(grid[row1][i])) {
        rect(i*gridSize, row1*gridSize, gridSize, gridSize);
        valid[row1][i] = true;
      }
      break;
    } else {
      rect(i*gridSize, row1*gridSize, gridSize, gridSize);
      valid[row1][i] = true;
    }
  }
}

void bHighlight() {
  for (int i = 1; (row1 - i >= 0) && (col1 - i >=0); i++) {
    if (grid[row1 - i][col1 - i] != ' ') {
      if (Character.isLowerCase(grid[row1 - i][col1 - i])) {
        rect((col1 - i) * gridSize, (row1 - i) * gridSize, gridSize, gridSize);
        valid[row1-i][col1-i] = true;
      }
      break;
    } else {
      rect((col1 - i) * gridSize, (row1 - i) * gridSize, gridSize, gridSize);
      valid[row1-i][col1-i] = true;
    }
  }
  for (int i = 1; (row1 + i < 8) && (col1 + i <8); i++) {
    if (grid[row1 + i][col1 + i] != ' ') {
      if (Character.isLowerCase(grid[row1 + i][col1 + i])) {
        rect((col1 + i) * gridSize, (row1 + i) * gridSize, gridSize, gridSize);
        valid[row1+i][col1+i] = true;
      }
      break;
    } else {
      rect((col1 + i) * gridSize, (row1 + i) * gridSize, gridSize, gridSize);
      valid[row1+i][col1+i] = true;
    }
  }
  for (int i = 1; (row1 + i < 8) && (col1 - i >=0); i++) {
    if (grid[row1 + i][col1 - i] != ' ') {
      if (Character.isLowerCase(grid[row1 + i][col1 - i])) {
        rect((col1 - i) * gridSize, (row1 + i) * gridSize, gridSize, gridSize);
        valid[row1+i][col1-i] = true;
      }
      break;
    } else {
      rect((col1 - i) * gridSize, (row1 + i) * gridSize, gridSize, gridSize);
      valid[row1+i][col1-i] = true;
    }
  }
  for (int i = 1; (row1 - i >= 0) && (col1 + i <8); i++) {
    if (grid[row1 - i][col1 + i] != ' ') {
      if (Character.isLowerCase(grid[row1 - i][col1 + i])) {
        rect((col1 + i) * gridSize, (row1 - i) * gridSize, gridSize, gridSize);
        valid[row1-i][col1+i] = true;
      }
      break;
    } else {
      rect((col1 + i) * gridSize, (row1 - i) * gridSize, gridSize, gridSize);
      valid[row1-i][col1+i] = true;
    }
  }
}

void nHighlight() {
  if (row1 - 2 >=0 && col1 + 1 < 8) {
    if (grid[row1 - 2][col1 + 1] == ' ' || Character.isLowerCase(grid[row1 - 2][col1 + 1])) {
      rect((col1 + 1) * gridSize, (row1 - 2) * gridSize, gridSize, gridSize);
      valid[row1 - 2][col1 + 1] = true;
    }
  }
  if (row1 + 2 < 8 && col1 - 1 >= 0) {
    if (grid[row1 + 2][col1 - 1] == ' ' || Character.isLowerCase(grid[row1 + 2][col1 - 1])) {
      rect((col1 - 1) * gridSize, (row1 + 2) * gridSize, gridSize, gridSize);
      valid[row1 + 2][col1 - 1] = true;
    }
  }
  if (row1 - 1 >=0 && col1 + 2 < 8) {
    if (grid[row1 - 1][col1 + 2] == ' ' || Character.isLowerCase(grid[row1 - 1][col1 + 2])) {
      rect((col1+2) * gridSize, (row1 - 1) * gridSize, gridSize, gridSize);
      valid[row1 - 1][col1 + 2] = true;
    }
  }
  if (row1 + 1 < 8 && col1 - 2 >= 0) {
    if (grid[row1 + 1][col1 - 2] == ' ' || Character.isLowerCase(grid[row1 + 1][col1 - 2])) {
      rect((col1-2) * gridSize, (row1 + 1) * gridSize, gridSize, gridSize);
      valid[row1 + 1][col1 - 2] = true;
    }
  }
  if (row1 + 1 < 8 && col1 + 2 < 8) {
    if (grid[row1 + 1][col1 + 2] == ' ' || Character.isLowerCase(grid[row1 + 1][col1 + 2])) {
      rect((col1+2) * gridSize, (row1 + 1) * gridSize, gridSize, gridSize);
      valid[row1 + 1][col1 + 2] = true;
    }
  }
  if (row1 - 1 >=0 && col1 - 2 >= 0) {
    if (grid[row1 - 1][col1 - 2] == ' ' || Character.isLowerCase(grid[row1 - 1][col1 - 2])) {
      rect((col1-2) * gridSize, (row1 - 1) * gridSize, gridSize, gridSize);
      valid[row1 - 1][col1 - 2] = true;
    }
  }
  if (row1 + 2 < 8 && col1 + 1 < 8) {
    if (grid[row1 + 2][col1 + 1] == ' ' || Character.isLowerCase(grid[row1 + 2][col1 + 1])) {
      rect((col1+1) * gridSize, (row1 + 2) * gridSize, gridSize, gridSize);
      valid[row1 + 2][col1 + 1] = true;
    }
  }
  if (row1 - 2 >=0 && col1 - 1 >= 0) {
    if (grid[row1 - 2][col1-1] == ' ' || Character.isLowerCase(grid[row1 - 2][col1-1])) {
      rect((col1-1) * gridSize, (row1 - 2) * gridSize, gridSize, gridSize);
      valid[row1 - 2][col1 - 1] = true;
    }
  }
}

void qHighlight() {
  bHighlight();
  rHighlight();
}

void kHighlight() {
  for (int i = row1 - 1; i <= row1 + 1; i++) {
    for (int j = col1 - 1; j <= col1 + 1; j++) {
      if (i >= 0 && i < 8 && j >=0 && j < 8) {
        if(Character.isLowerCase(grid[i][j]) || grid[i][j] == ' '){
          rect(j * gridSize, i * gridSize, gridSize,  gridSize);
          valid[i][j] = true;
        }
      }
    }
  }
}

void pHighlight(){
  if(row1 == 1){
    rect(col1 * gridSize, (row1 + 1) * gridSize, gridSize, gridSize);
    rect(col1 * gridSize, (row1 + 2) * gridSize, gridSize, gridSize);
    valid[row1 + 1][col1] = true;
    valid[row1 + 2][col1] = true;
  }else if(row1 < 7){
    rect(col1 * gridSize, (row1 + 1) * gridSize, gridSize, gridSize);
    valid[row1 + 1][col1] = true;
  }
  if( row1 < 7 && col1 > 0 && Character.isLowerCase(grid[row1 + 1][col1 - 1])){
    rect((col1 - 1) * gridSize, (row1 + 1) * gridSize, gridSize, gridSize);
    valid[row1 + 1][col1 - 1] = true;
  }
  if(row1 < 7 && col1 < 7 && Character.isLowerCase(grid[row1 + 1][col1 + 1])){
    rect((col1 + 1) * gridSize, (row1 + 1) * gridSize, gridSize, gridSize);
    valid[row1 + 1][col1 + 1] = true;
  }
}

void receiveMove(){
  Client myClient = myServer.available();
  if(myClient != null){
    String incoming = myClient.readString();
    int r1 = int(incoming.substring(0,1));
    int c1 = int(incoming.substring(2,3));
    int r2 = int(incoming.substring(4,5));
    int c2 = int(incoming.substring(6,7));
    grid[r2][c2] = grid[r1][c1];
    grid[r1][c1] = ' ';
    clickable = true;
    }
}
void drawBoard(){
 for(int i = 0;i<8;i++){
    for(int j = 0;j<8;j++){
      noStroke();
      if(i%2 == j%2){
        fill(lightbrown);
      }else{
        fill(darkbrown);
      }
      rect(i *gridSize, j * gridSize, gridSize, gridSize);
    }
  }
}

void drawPieces(){
  for(int i = 0;i<8;i++){
    for(int j = 0;j<8;j++){
      if(grid[i][j] == 'R'){
        image(brook,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'r'){
        image(wrook,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'B'){
        image(bbishop,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'b'){
        image(wbishop,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'N'){
        image(bknight,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'n'){
        image(wknight,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'Q'){
        image(bqueen,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'q'){
        image(wqueen,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'K'){
        image(bking,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'k'){
        image(wking,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'P'){
        image(bpawn,j*gridSize,i*gridSize,gridSize,gridSize);
      }else if(grid[i][j] == 'p'){
        image(wpawn,j*gridSize,i*gridSize,gridSize,gridSize);
      }
    }
  }
}

void movePieces(int y1, int x1, int y2, int x2){
    grid[y2][x2] = grid[y1][x1];
    grid[y1][x1] = ' ';
    myServer.write(y1 + "," + x1 + "," + y2 + "," + x2);
}

void mouseReleased(){
  if(clickable){
    if(firstClick){
      row1 = mouseY/gridSize;
      col1 = mouseX/gridSize;
      firstClick = false;
      if(Character.isLowerCase(grid[row1][col1])){
        row1 = -1;
        col1 = -1;
        firstClick = true;
      }
    }else{
      row2 = mouseY/gridSize;
      col2 = mouseX/gridSize;
      if(valid[row2][col2]){
      movePieces(row1,col1,row2,col2);
      clickable = false;
      }else{
      clickable = true;
      }
      row1 = -1;
      row2 = -1;
      col1 = -1;
      col2 = -1;
      firstClick = true;
      
    }
  }
}

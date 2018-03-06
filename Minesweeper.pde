


import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; 
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); 
public boolean isLosed = false; 

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j);
      }
    }
    
    for(int i = 0; i < 50; i++){
    setBombs();      
    }
}
public void setBombs()
{
    int bombRow = (int)(Math.random()*NUM_ROWS);
    int bombCol = (int)(Math.random()*NUM_COLS);
    if(bombs.contains(buttons[bombRow][bombCol])){
    setBombs();
    }
    else{
    bombs.add(buttons[bombRow][bombCol]);
    }      
}

public void draw ()
{
    background( 0 );
    if(isWon()){
        displayWinningMessage();
        noLoop();
    }
    if(isLosed){
        displayLosingMessage();
        noLoop();
    }
}
public boolean isWon()
{
 for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (!bombs.contains(buttons[i][j]) && buttons[i][j].isClicked() == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("o");
  buttons[9][8].setLabel("u");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("o");
  buttons[9][12].setLabel("s");
  buttons[9][13].setLabel("e");
}
public void displayWinningMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("o");
  buttons[9][8].setLabel("u");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("W");
  buttons[9][11].setLabel("i");
  buttons[9][12].setLabel("n");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(bombs.contains(this)){
          isLosed = true;        
        }
        else if(countBombs(r,c) > 0){
          setLabel(str(countBombs(r,c)));
        }
        else{
          for(int i = -1; i <= 1; i++){
            for(int j = -1; j <= 1; j++){
              if(isValid(r + i, c + j) && !buttons[r + i][c + j].isClicked()){
              buttons[r + i][c + j].mousePressed();
            }
          }
        }
        }
        
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
        if (!isClicked() && keyPressed && mouseX > x && mouseX < x + 20 && mouseY > y && mouseY < y+20) {
            marked = !marked;
            if (!marked) {
              clicked = false;
            }
        }
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0){
          return true;
        }
        else{
          return false;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = -1; i <= 1; i++){
          for(int j = -1; j <= 1; j++){
          if(isValid(row + i, col + j) && bombs.contains(buttons[row + i][col + j])){
            numBombs++;
            }
          }
        }
        return numBombs;
    }
}
//http://www.hermetic.ch/pca/algorithms.htm#vr

int max_health;

class Cell
{
  int infection;
  boolean exists;
  
  Cell(int infec, boolean ex)
  {
    infection = infec;
    exists = ex;
  }
  
  Cell(Cell other)
  {
    infection = other.infection;
    exists = other.exists;
  }
}

int XSIZE = 100;
int YSIZE = 100;

Cell[][] currentCells;
Cell[][] nextCells;
int generation;

void initCells()
{
  for(int x = 0; x < XSIZE; x++)
  {
    for(int y = 0; y < YSIZE; y++)
    {
      int inf = max_health;
      boolean ex = random(1) < 0.5;
      Cell c = new Cell(inf, ex);
      currentCells[x][y] = new Cell(c);
      nextCells[x][y] = new Cell(c);
    } 
  }
}

void copyCells()
{
  for(int x = 0; x < XSIZE; x++)
  {
    for(int y = 0; y < YSIZE; y++)
    {
      currentCells[x][y] = new Cell(nextCells[x][y]);
    } 
  }
}

void calculateGeneration()
{
  
  for(int x = 0; x < XSIZE; x++)
  {
    for(int y = 0; y < YSIZE; y++)
    {
      Cell current = currentCells[x][y];
      if(current.exists)
      {
        //DO
        if(current.infection == max_health)
        {
          //should infect?
          if(random(1) < (300 / 100000.0f))
          {
            //infect this cell!!
            nextCells[x][y].infection --;
          }
          else
          {
            //perhaps multiply?
            if(random(1) < (3 / 100.f))
            {
              //put a cell in a random adjacent empty spot
              int tried = 0;
              int randstart = (int) random(0, 8);
              boolean found = false;
              while(tried < 8 && !found)
              {
                if(!cellExistsAroundCell(x, y, tried + randstart))
                {
                  putNewCellAt(x, y, tried + randstart);
                  found = true;
                }
                tried++;
              } //finding spot for new cell
            } //reproduce
          } //not infected 
        } //healthy cell
        else
        {
          //not healthy cell
          if(current.infection > 1)
          {
            nextCells[x][y].infection--;
          }
          else
          {
            nextCells[x][y].exists = false;
            if(random(1) < (30/100.0f))
            {
              //infect surrounding cells
              for(int i = 0; i < 8; i++)
              {
                Cell c = getNextCellAt(x, y, i);
                if(c.exists && c.infection > 1)
                {
                  c.infection--;
                }
              }
            }
          }
        }
      } //cell exists
    } //for y
  } //for x
  
  copyCells();
}

void putNewCellAt(int x, int y, int index)
{
  Cell c = getNextCellAt(x, y, index);
  c.infection = max_health;
  c.exists = true;
}

Cell getNextCellAt(int x, int y, int index)
{
  index = index % 8;
  int targetx = x, targety = y;
  switch(index)
  {
    case 0:
      targetx --;
      break;
    case 1:
      targetx --;
      targety --;
      break;
    case 2:
      targety --;
      break;
    case 3:
      targety--;
      targetx++;
      break;
     case 4:
       targetx++;
       break;
     case 5:
       targetx++;
       targety++;
       break;
     case 6:
       targety++;
       break;
     case 7:
       targety++;
       targetx--;
       break;
  }
  
  Cell c = getNextCellAt(targetx, targety);
  return c;
}

boolean cellExistsAroundCell(int x, int y, int index)
{
  Cell c = getNextCellAt(x, y, index);
  return c.exists;
}

Cell getNextCellAt(int x, int y)
{
  x = (x + XSIZE) % XSIZE;
  y = (y + YSIZE) % YSIZE;
  return nextCells[x][y];
}

void update()
{
  //if(frameCount % 60 == 0)
  {
    //next generation
    calculateGeneration();
  }
}

void drawCells()
{
  //sizes
  float wid = width / ((float)XSIZE);
  float hei = height / ((float)YSIZE);
    
  for(int x = 0; x < XSIZE; x++)
  {
    for(int y = 0; y < YSIZE; y++)
    {
      Cell current = currentCells[x][y];
      if(current.exists)
      {
        int thegray = 255 / max_health;
        ellipseMode(CORNER);
        noStroke();
        fill(thegray * current.infection);
        float factor = 0.8;
        ellipse(x*wid, y*hei, wid * factor, hei * factor);
      }
    } 
  }
}

void setup () 
{
  size(500, 500);
  smooth();
  generation = 0;
  
  currentCells = new Cell[XSIZE][YSIZE];
  nextCells = new Cell[XSIZE][YSIZE];
  max_health = 10;

  //make cells  
  initCells();
}

void draw ()
{
  background(0);
  
  update();
  
  drawCells();
  
}

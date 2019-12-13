//Fractal Carpet
int[][] rule = { //We start out with the classic Sierpinski Carpet
{0,0,0,
 0,0,0, //From 0
 0,0,0},
 
{1,1,1,
 1,0,1, //From 1
 1,1,1}
};
int initial = 1;

int WINDOW_POWER = 6; //maximum is 6 (Decrease to increase performance, Increase to see more coolness)
int WINDOW_SIZE = 729; //Size of the window (if you change this, change the parameters to size as well)
int SHOW_TOP_LEVEL = 1; //Show the grid

int getReplacement(int rel_x, int rel_y, int state)
{
  /*
  rel_x is in the range -1 to 1.
  rel_y is in the range -1 to 1.
  state is either 1 or 0.
  
  This function returns the replacement that should be made for a tile with state state.
  */
    int index = 0;
    index+=(1+rel_x);
    index+=(1+rel_y)*3;
    
    return rule[state][index];
}

int getIndex(int size, int x, int y)
{
  return y*size+x;
}

int getAxisSize(ArrayList<Integer> toGet)
{
  //Get axis size in one direction.
  return int(sqrt(toGet.size()));
}

int getCoordinate(ArrayList<Integer> toSearch, int x, int y)
{
  return toSearch.get(getIndex(getAxisSize(toSearch), x, y));
}

void setCoordinate(ArrayList<Integer> toSearch, int x, int y, int new_value)
{
  //println("      getAxisSize(toSearch) = ", getAxisSize(toSearch));
  toSearch.set(getIndex(getAxisSize(toSearch), x, y), new_value);
}

void setBlock(ArrayList<Integer> parent, ArrayList<Integer> child, int parent_x, int parent_y)
{
  int parent_state = getCoordinate(parent, parent_x, parent_y); //What to transform
  int child_x_origin = (3*parent_x)+1;
  int child_y_origin = (3*parent_y)+1;
  
  //println("  Setting block in child at parent coordinates (", parent_x, ",", parent_y, ")");
  //println("    The parent's axis-size is ", getAxisSize(parent), " (#Elements = ", parent.size(), "), and the child's axis-size is ", getAxisSize(child), " (#Elements = ", child.size(), ")");
  for (int child_relative_y = -1; child_relative_y <= 1; child_relative_y++)
  {
    for (int child_relative_x = -1; child_relative_x <= 1; child_relative_x++)
    {
      int child_x = child_x_origin+child_relative_x;
      int child_y = child_y_origin+child_relative_y;
      int child_state = getReplacement(child_relative_x, child_relative_y, parent_state);
      //println("    Setting the relative coordinates (", child_relative_x, ",", child_relative_y, "), which is (", child_x, ",", child_y, "), to state ", child_state, ". The index is ", getIndex(getAxisSize(child), child_x, child_y));
      setCoordinate(child, child_x, child_y, child_state);
    }
  }
  //println("  All Done! :D");
}

ArrayList<Integer> iterate(ArrayList<Integer> input, int iteration)
{
  //println("The number of elements is ", input.size(), " and the iteration is ", iteration, ". Predicted number is 3^iteration^2 = ", pow(pow(3, iteration-1), 2));
  if (iteration == 0)
  {
    ArrayList<Integer> toReturn = new ArrayList();
    toReturn.add(initial);
    return toReturn;
  }
  
  //Sizes are along one direction.
  int current_size = getAxisSize(input);
  int next_size = 3*current_size;
  
  ArrayList<Integer> toReturn = new ArrayList();
  for (int i = 0; i < int(pow(next_size, 2)); i++)
  {
    toReturn.add(0);
  }
  
  for (int x = 0; x < current_size; x++)
  {
    for (int y = 0; y < current_size; y++)
    {
      setBlock(input, toReturn, x, y);
    }
  }
  //println("Iteration complete!");
  
  return toReturn;
}

ArrayList<Integer> createFractalCarpet(int iterations)
{
  ArrayList<Integer> current = new ArrayList<Integer>();
  for (int i = 0; i < iterations; i++)
  {
    //println("Iteration ", i);
    current = iterate(current, i);
  }
  return current;
}

void drawScaledPixel(int x, int y, color the_color)
{
  //There should be 3**WINDOW_POWER scaled pixels.
  int number_of_scaled_pixels_axis = int(pow(3, WINDOW_POWER-1));
  //The size of a scaled pixel should be WINDOW_SIZE/# of SPs
  int size_of_scaled_pixel = WINDOW_SIZE/number_of_scaled_pixels_axis;
  
  int true_x = (size_of_scaled_pixel*x);
  int true_y = (size_of_scaled_pixel*y);
  
  noStroke();
  fill(the_color);
  rect(true_x, true_y, size_of_scaled_pixel, size_of_scaled_pixel);
}

void printRule()
{
  println("----------------------");
  
  println("   ",rule[0][0], rule[0][1], rule[0][2]);
  println("0->",rule[0][3], rule[0][4], rule[0][5]);
  println("   ",rule[0][6], rule[0][7], rule[0][8]);
  
  println("");
  
  println("   ",rule[1][0], rule[1][1], rule[1][2]);
  println("1->",rule[1][3], rule[1][4], rule[1][5]);
  println("   ",rule[1][6], rule[1][7], rule[1][8]);
  
  println("----------------------");
}

void drawCarpet()
{
  ArrayList<Integer> carpet = createFractalCarpet(WINDOW_POWER);
  color black = color(0);
  color white = color(255);
  
  printRule();
  
  for (int x = 0; x < getAxisSize(carpet); x++)
  {
    for (int y = 0; y < getAxisSize(carpet); y++)
    {
      if (getCoordinate(carpet, x, y) == 0)
      {
        drawScaledPixel(x, y, white);
      }
      else
      {
        drawScaledPixel(x, y, black);
      }
    }
  }
  
  if (SHOW_TOP_LEVEL == 1)
  {
    drawGrid();
  }
}

void editRule(int the_rule)
{
  int x = mouseX/(WINDOW_SIZE/3);
  int y = mouseY/(WINDOW_SIZE/3);
  int current = rule[the_rule][getIndex(3, x, y)];
  if (current == 1)
  {
    rule[the_rule][getIndex(3, x, y)] = 0;
  }
  else
  {
    rule[the_rule][getIndex(3, x, y)] = 1;
  }
}

void drawGrid()
{
  stroke(0);
  int size = WINDOW_SIZE/3;
  for (int x = 0; x < 3; x++)
  {
    int true_x = x*size;
    line(true_x, 0, true_x, 3*size);
  }
  for (int y = 0; y < 3; y++)
  {
    int true_y = y*size;
    line(0, true_y, 3*size, true_y);
  }
}

void setup() {
  size(729, 729);
  drawCarpet();
  
  println("WELCOME! Use your left mouse button to chage the 1-rule, and your right mouse button to change the 0-rule.");
  println("Watch the terminal to see the current ruleset.");
  println("Don't get lost :)");
}

void mouseClicked()
{
  if (mouseButton == LEFT) {
    editRule(1);
  } else if (mouseButton == RIGHT) {
    editRule(0);
  }
  
  drawCarpet();
}

void draw()
{
  //fill(255);
  //rect(0, 0, WINDOW_SIZE, WINDOW_SIZE);
  //drawGrid();
}

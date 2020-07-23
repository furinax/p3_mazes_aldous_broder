import java.util.Set;
import java.util.Iterator;

Grid g;

void setup(){
  size(800,600);
  g = new Grid(8, 6);
  (new AlduousBroder()).on(g);
}

void draw() {
  background(0);
  g.onDraw();
}


class AlduousBroder {
  void on(Grid g){
    Cell c = g.randomCell();
    int unvisited = g.size() - 1;
    
    while (unvisited > 0) {
      Cell[] neighbors = c.neighbors();
      Cell neighbor = neighbors[(int)random(neighbors.length)];
      if( neighbor.links().isEmpty() )
      {
        c.link(neighbor,true);
        unvisited -= 1;
      }
      c = neighbor;
    }
  }
}


class Grid {
  Cell[][] cells;
  Grid(int h, int w){
    cells = new Cell[h][w];
    prepare();
    configure();
  }
  
  Cell get(int h, int w){
    if( h < 0 || h > cells.length - 1)
      return null;
    if( w < 0 || w > cells[0].length - 1)
      return null; 
    return cells[h][w];
  }
  
  Cell randomCell() {
    return cells[(int)random(cells.length)][(int)random(cells[0].length)];
  }
  
  Cell[] eachCell() {
    Cell[] retVal = new Cell[cells.length*cells[0].length];
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        retVal[h*cells[0].length + w] = cells[h][w];
      }
    }
    return retVal;
  }
  
  
  int size() {
     return cells.length * cells[0].length;
  }
  
  void prepare(){
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        cells[h][w] = new Cell(h, w);
      }
    }
  }
  
  void configure() {
    for( int h = 0; h < cells.length ; h++ )
    {
      for( int w = 0 ; w < cells[0].length; w++ ){
        cells[h][w].up = this.get(h-1,w);
        cells[h][w].down = this.get(h+1,w);
        cells[h][w].left = this.get(h,w-1);
        cells[h][w].right = this.get(h,w+1);
      }
    }
  }
  
  void onDraw(){
    stroke(255);
    strokeWeight(2);
    int MARGIN = 50;
    int LEFT = MARGIN, TOP = MARGIN, RIGHT = width - MARGIN, BOTTOM = height - MARGIN;
    int STEP_H = (BOTTOM - TOP) / cells.length;
    int STEP_W = (RIGHT - LEFT) / cells[0].length;
    for( int h = 0; h < cells.length ; h++ ){
      for( int w = 0 ; w < cells[0].length; w++ ){
        PVector origin = new PVector(LEFT + STEP_W * w, TOP + STEP_H * h);
        Cell current_cell = cells[h][w];
        if( current_cell.up == null || !current_cell.links().contains(current_cell.up))
          line(origin.x, origin.y, origin.x+STEP_W, origin.y);
        if( current_cell.down == null || !current_cell.links().contains(current_cell.down))
          line(origin.x, origin.y+STEP_H, origin.x+STEP_W, origin.y+STEP_H);
        if( current_cell.left == null || !current_cell.links().contains(current_cell.left))
          line(origin.x, origin.y, origin.x, origin.y+STEP_H);
        if( current_cell.right == null || !current_cell.links().contains(current_cell.right))
          line(origin.x+STEP_W, origin.y, origin.x+STEP_W, origin.y+STEP_H);
      }
    }
    
  }
}

class Cell {
  PVector pos;
  Cell up, down, left, right;
  HashMap<Cell, Boolean> links;
  
  Cell(int x, int y){
    pos = new PVector(x, y);
    links = new HashMap<Cell, Boolean>();
  }
  
  void link(Cell c, boolean bidi) {
    links.put(c,true);
    if( bidi )
      c.link(this, false);
  }
  
  void unlink( Cell c, boolean bidi) {
    links.remove(c);
    if(bidi)
      c.unlink(this, false);
  }
  
  Set<Cell> links(){
    return links.keySet();
  }
  
  boolean isLinked(Cell c) {
    return links.containsKey(c);
  }
  
  Cell[] neighbors() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    if( this.up != null )
      neighbors.add(this.up);
    if( this.down != null )
      neighbors.add(this.down);
    if( this.left != null )
      neighbors.add(this.left);
    if( this.right != null )
      neighbors.add(this.right);
    
    Cell[] arr = new Cell[neighbors.size()];
    arr = neighbors.toArray(arr);
    return arr;
  }
  
}

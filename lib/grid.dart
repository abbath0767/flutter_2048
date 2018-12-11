import 'dart:math';

List<List<int>> blankGrid() {
  List<List<int>> rows = [];

  for (int i = 0; i < 4; i++) {
    rows.add([0, 0, 0, 0]);
  }

  return rows;
}

List<List<int>> addNumber(List<List<int>> grid, List<List<int>> gridNew) {
  List<Point> emptyPoints = [];

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) {
        emptyPoints.add(Point(i, j));
      }
    }
  }

  if (emptyPoints.length > 0) {
    Random rand = Random();
    int spotRandomIndex = rand.nextInt(emptyPoints.length);
    Point spot = emptyPoints[spotRandomIndex];
    grid[spot.x][spot.y] = rand.nextBool() ? 4 : 2;
    gridNew[spot.x][spot.y] = 1;
  }

  return grid;
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

List<List<int>> transposeGrid(List<List<int>> grid) {
  List<List<int>> newGrid = blankGrid();
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      newGrid[i][j] = grid[j][i];
    }
  }
  return newGrid;
}

List<List<int>> flipGrid(List<List<int>> grid) {
  for (int i = 0; i < 4; i++) {
    List<int> row = grid[i];
    grid[i] = row.reversed.toList();
  }
  return grid;
}

List<List<int>> copyGrid(List<List<int>> grid) {
  List<List<int>> extraGrid = blankGrid();
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      extraGrid[i][j] = grid[i][j];
    }
  }
  return extraGrid;
}

bool compare(List<List<int>> a,List<List<int>> b){
  for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
      if(a[i][j] != b[i][j]){
        return false;
      }
    }
  }
  return true;
}
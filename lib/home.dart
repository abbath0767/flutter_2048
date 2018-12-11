import 'package:flutter/material.dart';
import 'package:twenty_forty_seven/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twenty_forty_seven/constant.dart';
import 'package:twenty_forty_seven/grid.dart';
import 'package:twenty_forty_seven/tile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  SharedPreferences _sharedPreferences;
  int scoreCount = 0;

  double squareSize;
  double gameBoardSize;

  List<List<int>> grid = [];
  List<List<int>> gridNew = [];
  bool isGameOver = false;
  bool isGameWon = false;

  @override
  void initState() {
    grid = blankGrid();
    gridNew = blankGrid();
    addNumber(grid, gridNew);
    addNumber(grid, gridNew);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    squareSize = (screenWidht - (screenWidht / 10) * 2) / 4;
    gameBoardSize = (squareSize * 4) + 40;

    return Scaffold(
      appBar: AppBar(
        title: Text('2048'),
        backgroundColor: Color(ColorCustom.primaryColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _getScoreContainer(),
              _getGameField(),
              _getBottomButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _getScoreContainer() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: 200,
          height: 80,
          decoration: BoxDecoration(
              color: Color(ColorCustom.primaryColor),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Score:",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  "$scoreCount",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ));
  }

  Widget _getGameField() {
    return Container(
        height: gameBoardSize,
        width: gameBoardSize,
        color: Color(ColorCustom.primaryColor),
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _getGestureDetector(),
          ),
          isGameOver
              ? Container(
                  height: gameBoardSize,
                  width: gameBoardSize,
                  color: Color(ColorCustom.transperentWhite),
                  child: Center(
                    child: Text(
                      'Game Over',
                      style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorCustom.primaryColor)),
                    ),
                  ),
                )
              : SizedBox(),
          isGameWon
              ? Container(
                  height: gameBoardSize,
                  width: gameBoardSize,
                  color: Color(ColorCustom.transperentWhite),
                  child: Center(
                    child: Text(
                      'You Won this Game!',
                      style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorCustom.primaryColor)),
                    ),
                  ),
                )
              : SizedBox()
        ]));
  }

  Widget _getBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Color(ColorCustom.primaryColor),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _onRefreshPressed();
                    }),
              )),
          Container(
              decoration: BoxDecoration(
                  color: Color(ColorCustom.primaryColor),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text('Best Score:',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    FutureBuilder<String>(
                        future: _getBestScore(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Text(snapshot.data,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold));
                          else
                            return Text('0',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold));
                        })
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _onRefreshPressed() {
    setState(() {
      grid = blankGrid();
      gridNew = blankGrid();
      grid = addNumber(grid, gridNew);
      grid = addNumber(grid, gridNew);
      scoreCount = 0;
      isGameOver = false;
      isGameWon = false;
    });
  }

  Future<String> _getBestScore() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    int best = _sharedPreferences.get(Constants.BEST_SCORE_KEY);
    if (best == null) {
      best = 0;
    }
    return best.toString();
  }

  Widget _getGestureDetector() {
    return GestureDetector(
      child: GridView.count(
        primary: false,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: _getGrid(),
      ),
      onVerticalDragEnd: (drag) {
        if (drag.primaryVelocity < 0)
          _handleGesture(_GestureMotion.UP);
        else if (drag.primaryVelocity > 0) _handleGesture(_GestureMotion.DOWN);
      },
      onHorizontalDragEnd: (drag) {
        if (drag.primaryVelocity > 0)
          _handleGesture(_GestureMotion.LEFT);
        else if (drag.primaryVelocity < 0) _handleGesture(_GestureMotion.RIGHT);
      },
    );
  }

  List<Widget> _getGrid() {
    List<Widget> grids = [];

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        int num = grid[i][j];
        int color;
        String stringValue;
        switch (num) {
          case 0:
            {
              color = ColorCustom.empty;
              stringValue = "";
              break;
            }
          case 2:
          case 4:
            {
              color = ColorCustom.color2_4;
              break;
            }
          case 8:
          case 64:
          case 256:
            {
              color = ColorCustom.color8_64_256;
              break;
            }
          case 16:
          case 32:
          case 1024:
            {
              color = ColorCustom.color16_32_1024;
              break;
            }
          case 128:
          case 512:
            {
              color = ColorCustom.color128_512;
              break;
            }
          default:
            {
              color = ColorCustom.color_win;
              break;
            }
        }
        stringValue = num.toString();

        double size;
        int len = stringValue.length;
        switch (len) {
          case 1:
          case 2:
            {
              size = 40.0;
              break;
            }
          case 3:
            {
              size = 30.0;
              break;
            }
          case 4:
            {
              size = 20.0;
              break;
            }
        }
        grids.add(Tile(stringValue, squareSize, squareSize, color, size));
      }
    }

    return grids;
  }

  void _handleGesture(_GestureMotion motion) {
    bool flipped = false;
    bool played = true;
    bool rotated = false;

    switch (motion) {
      case _GestureMotion.UP:
        {
          setState(() {
            grid = transposeGrid(grid);
            grid = flipGrid(grid);
            rotated = true;
            flipped = true;
          });
          break;
        }
      case _GestureMotion.DOWN:
        {
          setState(() {
            grid = transposeGrid(grid);
            rotated = true;
          });
          break;
        }
      case _GestureMotion.LEFT:
        {
          break;
        }
      case _GestureMotion.RIGHT:
        {
          setState(() {
            grid = flipGrid(grid);
            flipped = true;
          });
          break;
        }
    }

    if (played) {
      List<List<int>> past = copyGrid(grid);
      for (int i = 0; i < 4; i++) {
        setState(() {
          List result = _operate(grid[i], scoreCount);
          scoreCount = result[0];
          grid[i] = result[1];
        });
      }
      setState(() {
        grid = addNumber(grid, gridNew);
      });
      bool changed = compare(past, grid);
      if (flipped) {
        setState(() {
          grid = flipGrid(grid);
        });
      }

      if (rotated) {
        setState(() {
          grid = transposeGrid(grid);
        });
      }

      if (changed) {
        setState(() {
          grid = addNumber(grid, gridNew);
        });
      }

      bool gameover = _isGameOver(grid);
      if (gameover) {
        setState(() {
          isGameOver = true;
        });
      }

      bool gamewon = _isGameWon(grid);
      if (gamewon) {
        setState(() {
          isGameWon = true;
        });
      }
    }
  }

  List _operate(List<int> row, score) {
    row = _slide(row);
    List result = _combine(row, score);
    int sc = result[0];
    row = result[1];
    row = _slide(row);

    return [sc, row];
  }

  List<int> _slide(List<int> row) {
    List<int> arr = _filter(row);
    int missing = 4 - arr.length;
    List<int> zeroes = _zeroArray(missing);
    arr = zeroes + arr;
    return arr;
  }

  List<int> _filter(List<int> row) {
    List<int> temp = [];
    for (int i = 0; i < row.length; i++) {
      if (row[i] != 0) {
        temp.add(row[i]);
      }
    }
    return temp;
  }

  List<int> _zeroArray(int missing) {
    List<int> zeroes = [];
    for (int i = 0; i < missing; i++) {
      zeroes.add(0);
    }
    return zeroes;
  }

  List _combine(List<int> row, score) {
    for (int i = 3; i >= 1; i--) {
      int a = row[i];
      int b = row[i - 1];
      if (a == b) {
        row[i] = a + b;
        score += row[i];
        int sc = _sharedPreferences.getInt(Constants.BEST_SCORE_KEY);
        if (sc == null) {
          _sharedPreferences.setInt(Constants.BEST_SCORE_KEY, score);
        } else if (score > sc) {
          _sharedPreferences.setInt(Constants.BEST_SCORE_KEY, score);
        }

        row[i - 1] = 0;
      }
    }
    return [score, row];
  }

  bool _isGameOver(List<List<int>> grid) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 0) {
          return false;
        }
        if (i != 3 && grid[i][j] == grid[i + 1][j]) {
          return false;
        }
        if (j != 3 && grid[i][j] == grid[i][j + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  bool _isGameWon(List<List<int>> grid) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 2048) {
          return true;
        }
      }
    }
    return false;
  }
}

enum _GestureMotion { UP, DOWN, LEFT, RIGHT }

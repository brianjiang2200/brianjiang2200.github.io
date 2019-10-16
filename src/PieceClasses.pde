//PIECE SUPERCLASS
class Piece {

  //MATERIAL VALUE
  int material_value;
  //X COORDINATE IN PIXELS
  int x_coord;
  //Y COORDINATE IN PIXELS
  int y_coord;
  //ROW OCCUPIED BY PIECE (0-7)
  int SquareX; 
  //COLUMN OCCUPIED BY PIECE (0-7)
  int SquareY; 
  //COLOUR
  boolean iswhite;
  //HAS PREVIOUSLY BEEN MOVED
  boolean has_moved;
  //CAN BE CAPTURED EN PASSANT
  boolean en_passant;
  //IMAGE FOR PIECE
  PImage visual;
  //LETTER FOR NOTATION
  String letter; 

  //CONSTRUCTOR
  Piece(int xpos, int ypos, boolean white) {
  x_coord = xpos; 
  y_coord = ypos;
  SquareX = xpos/100; 
  SquareY = ypos/100; 
  iswhite = white;  
  }
  
  //MOVE IS LEGAL
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    //will be overridden by subclasses
    return true; 
  }
  
  //CHECK GIVEN BY THIS PIECE CAN BE BLOCKED
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
    //will be overridden by subclasses
    return false; 
  }
  
  //VERIFY THAT MOVE MADE DOES NOT PUT KING IN CHECK
  boolean verify_not_check(Piece my_board[][], int new_y, int new_x) {
    Piece[][] local_board = duplicate_board(my_board);
    ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
    ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
    local_board[this.SquareY][this.SquareX].SquareY = new_y;
    local_board[this.SquareY][this.SquareX].SquareX = new_x; 
    local_board[new_y][new_x] = this; 
    local_board[this.SquareY][this.SquareX] = null;
    duplicate_protected_squares(local_board, whites_squares, blacks_squares);
    if (this.iswhite && copy_white_king.in_check(whites_squares, blacks_squares)) {
        return false; 
    }
    else if (!this.iswhite && copy_black_king.in_check(whites_squares, blacks_squares)) {
      return false; 
    }
    return true;
  }
  
  
  //DISPLAY PIECE
  void display() {
    image(visual, x_coord, y_coord, piecedim, piecedim); 
  }

  //ASSIGN PROTECTED SQUARES
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
     //overridden by subclasses
  }
  
  //ASSIGNS VISUAL TO PIECE
  void assign_visual(boolean highlight) {
    //overridden by subclasses
  }
  
}
 

class Pawn extends Piece { 

  Pawn(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white);
    material_value = 1;
    assign_visual(false); 
    letter = (white) ? "p" : "P"; 
  }
  
  void assign_visual(boolean highlight) {
      visual = (iswhite) ? whitepawnimg : blackpawnimg; 
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
   
    if (iswhite) {
  
      //FORWARD MOVEMENT FOR WHITE PAWNS
      if (x == SquareX && my_board[SquareY - 1][x] == null) { 
        if (y == SquareY - 1) {
          return verify_not_check(my_board, y, x);
        }
        if (SquareY == 6 && y == SquareY - 2 && my_board[SquareY - 2][x] == null) {
          return verify_not_check(my_board, y, x);
        }
      }
    
      if (y == SquareY - 1) {
        //CAPTURING TO THE LEFT OR RIGHT
        if ((x == SquareX - 1 || x == SquareX + 1) && my_board[SquareY - 1][x] != null && my_board[SquareY - 1][x].iswhite == false) {
          return verify_not_check(my_board, y, x); 
        }
        //EN PASSANT TO THE LEFT AND RIGHT
        else if ((x == SquareX - 1 || x == SquareX + 1) && my_board[SquareY][x] != null && my_board[SquareY][x].en_passant) {
          Piece[][] local_board = duplicate_board(my_board);
          ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
          ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
          local_board[SquareY][SquareX].SquareY = y;
          local_board[SquareY][SquareX].SquareX = x; 
          local_board[y][x] = this; 
          local_board[SquareY][SquareX] = null;
          local_board[y + 1][x] = null;
          duplicate_protected_squares(local_board, whites_squares, blacks_squares);
          if (copy_white_king.in_check(whites_squares, blacks_squares)) {
            return false; 
          }
          return true; 
        }
       }
      }
      
    else {
      //FORWARD MOVEMENT FOR BLACK PAWNS
      if (x == SquareX && my_board[SquareY + 1][x] == null) {
         if (y == SquareY + 1) {
            return verify_not_check(my_board, y, x);
         }
         if (SquareY == 1 && y == SquareY + 2 && piece_board[SquareY + 2][x] == null) {
           return verify_not_check(my_board, y, x);
         }
       }
      if (y == SquareY + 1) {
        //CAPTURING TO THE LEFT OR RIGHT
        if ((x == SquareX - 1 || x == SquareX + 1) && my_board[SquareY + 1][x] != null && my_board[SquareY + 1][x].iswhite == true) {
          return verify_not_check(my_board, y, x); 
        }
        //EN PASSANT TO THE LEFT AND RIGHT
        else if ((x == SquareX - 1 || x == SquareX + 1) && my_board[SquareY][x] != null && my_board[SquareY][x].en_passant) {
           Piece[][] local_board = duplicate_board(my_board);
           ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
           ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
           local_board[SquareY][SquareX].SquareY = y;
           local_board[SquareY][SquareX].SquareX = x; 
           local_board[y][x] = this; 
           local_board[SquareY][SquareX] = null;
           duplicate_protected_squares(local_board, whites_squares, blacks_squares);      
           if (copy_black_king.in_check(whites_squares, blacks_squares)) {
             return false; 
           }
           return true;
        }
      }
    }
   return false; 
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
     if (SquareY != 0 && SquareY != 7) {
      if (iswhite) {
        if (SquareX > 0) {
          NewProtected(SquareX - 1, SquareY - 1, this, white_protected);
        }
        if (SquareX < 7) {
          NewProtected(SquareX + 1, SquareY - 1, this, white_protected); 
        }
      }
      else {
        if (SquareX > 0) {
          NewProtected(SquareX - 1, SquareY + 1, this, black_protected); 
        }
        if (SquareX < 7) {
          NewProtected(SquareX + 1, SquareY + 1, this, black_protected); 
        }
      }
    }
  }
  
}

class Knight extends Piece {
  
  Knight(int xpos, int ypos, boolean white) {
     super(xpos, ypos, white); 
     material_value = 3;
     assign_visual(false);  
     letter = (white) ? "n" : "N"; 
  }
  
    void assign_visual(boolean highlight) {
      visual = (iswhite) ? whiteknightimg : blackknightimg; 
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
       if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    if (my_board[y][x] != null && my_board[y][x].iswhite == iswhite) {
      return false; 
    } 
    if (x == SquareX + 2 || x == SquareX - 2) {
      if (y == SquareY + 1 || y == SquareY - 1) {
        return verify_not_check(my_board, y, x);
      }
    }
    if (x == SquareX + 1 || x == SquareX - 1) {
      if (y == SquareY + 2 || y == SquareY - 2) {
        return verify_not_check(my_board, y, x);
      }
    } 
    }
    return false;  
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    if (iswhite) {
      NewProtected(SquareX - 2, SquareY - 1, this, white_protected); 
      NewProtected(SquareX - 2, SquareY + 1, this, white_protected); 
      NewProtected(SquareX - 1, SquareY - 2, this, white_protected); 
      NewProtected(SquareX - 1, SquareY + 2, this, white_protected); 
      NewProtected(SquareX + 1, SquareY - 2, this, white_protected); 
      NewProtected(SquareX + 1, SquareY + 2, this, white_protected); 
      NewProtected(SquareX + 2, SquareY - 1, this, white_protected); 
      NewProtected(SquareX + 2, SquareY + 1, this, white_protected); 
    }
    else {
      NewProtected(SquareX - 2, SquareY - 1, this, black_protected); 
      NewProtected(SquareX - 2, SquareY + 1, this, black_protected); 
      NewProtected(SquareX - 1, SquareY - 2, this, black_protected); 
      NewProtected(SquareX - 1, SquareY + 2, this, black_protected); 
      NewProtected(SquareX + 1, SquareY - 2, this, black_protected); 
      NewProtected(SquareX + 1, SquareY + 2, this, black_protected); 
      NewProtected(SquareX + 2, SquareY - 1, this, black_protected); 
      NewProtected(SquareX + 2, SquareY + 1, this, black_protected);
    }
  }

}

class Bishop extends Piece {
  
  Bishop(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white); 
    material_value = 3; 
    assign_visual(false);  
    letter = (white) ? "b" : "B"; 
  }
  
  void assign_visual(boolean highlight) {
      visual = (iswhite) ? whitebishopimg : blackbishopimg; 
  }
  
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
  
  //this already checks if a piece lands on the same square as itself. 
  if (my_board[y][x] != null && my_board[y][x].iswhite == iswhite) {
    return false; 
  }
  if (abs(y - SquareY) == abs(x - SquareX)) {
  
    if (y > SquareY && x > SquareX) {
      for (int z = 1; z < y - SquareY; ++z) {
        if (my_board[SquareY + z][SquareX + z] != null) {
          return false; 
        }
      }
    }
    else if (y > SquareY && x < SquareX) {
      for (int z = 1; z < y - SquareY; ++z) {
        if (my_board[SquareY + z][SquareX - z] != null) {
          return false; 
        }
      }
    }
    else if (y < SquareY && x > SquareX) {
      for (int z = 1; z < x - SquareX; ++z) {
        if (my_board[SquareY - z][SquareX + z] != null) {
          return false; 
        }
      }
    }
    else {
      for (int z = 1; z < SquareX - x; ++z) {
        if (my_board[SquareY - z][SquareX - z] != null) {
          return false;
        }
      }
    }
    return verify_not_check(my_board, y, x);
  }
    }
    return false; 
  }

  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    int z;
    if (iswhite) {
       NewProtected(SquareX - 1, SquareY - 1, this, white_protected); 
       NewProtected(SquareX - 1, SquareY + 1, this, white_protected);
       NewProtected(SquareX + 1, SquareY - 1, this, white_protected); 
       NewProtected(SquareX + 1, SquareY + 1, this, white_protected); 
          z = 1;
          while (check_null(my_board, SquareX - z, SquareY - z)) {
            NewProtected(SquareX - z - 1, SquareY - z - 1, this, white_protected);
            z++;
          }
          z = 1;
          while (check_null(my_board, SquareX - z, SquareY + z)) {
            NewProtected(SquareX - z - 1, SquareY + z + 1, this, white_protected);
            z++;
          }
          z = 1;
          while (check_null(my_board, SquareX + z, SquareY - z)) {
            NewProtected(SquareX + z + 1, SquareY - z - 1, this, white_protected);
            z++;
          }
          z = 1;
          while (check_null(my_board, SquareX + z, SquareY + z)) {
            NewProtected(SquareX + z + 1, SquareY + z + 1, this, white_protected);
            z++;
          }
    }
    else {
      NewProtected(SquareX - 1, SquareY - 1, this, black_protected); 
      NewProtected(SquareX - 1, SquareY + 1, this, black_protected);
      NewProtected(SquareX + 1, SquareY - 1, this, black_protected); 
      NewProtected(SquareX + 1, SquareY + 1, this, black_protected);
        z = 1;
        while (check_null(my_board, SquareX - z, SquareY - z)) {
          NewProtected(SquareX - z - 1, SquareY - z - 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, SquareX - z, SquareY + z)) {
          NewProtected(SquareX - z - 1, SquareY + z + 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, SquareX + z, SquareY - z)) {
          NewProtected(SquareX + z + 1, SquareY - z - 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, SquareX + z, SquareY + z)) {
          NewProtected(SquareX + z + 1, SquareY + z + 1, this, black_protected);
          z++;
        }
    }
  }
  
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
      if (king_x < SquareX && king_y < SquareY) {
        for (int k = 1; k < SquareY - king_y; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].iswhite != iswhite
                  && my_board[a][b].is_legal(my_board, for_white, for_black, SquareX - k, SquareY - k)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_x < SquareX && king_y > SquareY) {
        for (int k = 1; k < SquareX - king_x; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].iswhite != iswhite 
                  && my_board[a][b].is_legal(my_board, for_white, for_black, SquareX - k, SquareY + k)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_x > SquareX && king_y < SquareY) {
        for (int k = 1; k < SquareY - king_y; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].iswhite != iswhite 
                  && my_board[a][b].is_legal(my_board, for_white, for_black, SquareX + k, SquareY - k)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_x > SquareX && king_y > SquareY) {
        for (int k = 1; k < king_y - SquareY; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].iswhite != iswhite
                  && my_board[a][b].is_legal(my_board, for_white, for_black, SquareX + k, SquareY + k)) {
                    return true; 
                  }
            }
          }
        }
      }
    return false; 
  }
  
}

class Rook extends Piece { 
  
  Rook(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white); 
    material_value = 5; 
    assign_visual(false);  
    letter = (white) ? "r" : "R"; 
  }
  
   void assign_visual(boolean highlight) {
      visual = (iswhite) ? whiterookimg : blackrookimg; 
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
      if (my_board[y][x] != null && my_board[y][x].iswhite == iswhite) {
        return false; 
      } 
      if (x == SquareX && y > SquareY) {
        for (int z = SquareY + 1; z < y; z++) {
          if (my_board[z][x] != null) { 
            return false; 
          }
        }
      return verify_not_check(my_board, y, x);
      }
      else if (x == SquareX && y < SquareY) {
        for (int z = SquareY - 1; z > y; z--) {
          if (my_board[z][x] != null) {
            return false;
          }
        }
      return verify_not_check(my_board, y, x);
      }
      else if (y == SquareY && x > SquareX) {
        for (int z = SquareX + 1; z < x; z++) {
          if (my_board[y][z] != null) {
            return false; 
          }
        }
      return verify_not_check(my_board, y, x);
        }
      else if (y == SquareY) {
        for (int z = SquareX - 1; z > x; z--) {
          if (my_board[y][z] != null) {
            return false;
          }
        }
      return verify_not_check(my_board, y, x);
      }
    }
    return false; 
  }

  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    int z; 
    if (iswhite) {
      NewProtected(SquareX, SquareY + 1, this, white_protected); 
      NewProtected(SquareX, SquareY - 1, this, white_protected); 
      NewProtected(SquareX + 1, SquareY, this, white_protected); 
      NewProtected(SquareX - 1, SquareY, this, white_protected);
        z = 1;
        while (check_null(my_board, SquareX + z, SquareY)) {
          NewProtected(SquareX + z + 1, SquareY, this, white_protected); 
          z++;
        }
        z = 1; 
        while (check_null(my_board, SquareX - z, SquareY)) {
          NewProtected(SquareX - z - 1, SquareY, this, white_protected);
          z++;
        }
        z = 1; 
        while (check_null(my_board, SquareX, SquareY + z)) {
          NewProtected(SquareX, SquareY + z + 1, this, white_protected);
          z++;
        }
        z = 1; 
        while (check_null(my_board, SquareX, SquareY - z)) {
          NewProtected(SquareX, SquareY - z - 1, this, white_protected);
          z++;
        }
    }
    else {
      NewProtected(SquareX, SquareY + 1, this, black_protected); 
      NewProtected(SquareX, SquareY - 1, this, black_protected); 
      NewProtected(SquareX + 1, SquareY, this, black_protected); 
      NewProtected(SquareX - 1, SquareY, this, black_protected);
        z = 1;
        while (check_null(my_board, SquareX + z, SquareY)) {
          NewProtected(SquareX + z + 1, SquareY, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, SquareX - z, SquareY)) {
          NewProtected(SquareX - z -1, SquareY, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, SquareX, SquareY + z)) {
          NewProtected(SquareX, SquareY + z + 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, SquareX, SquareY - z)) {
          NewProtected(SquareX, SquareY - z - 1, this, black_protected);
          z++;
        }
    }
  }
  
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
    if (king_x == SquareX && king_y < SquareY) {
        for (int k = 1; k < SquareY - king_y; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].iswhite != iswhite
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, SquareX, SquareY - k)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_x == SquareX) {
        for (int k = 1; k < king_y - SquareY; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].iswhite != iswhite
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, SquareX, SquareY + k)) {
                    return true; 
                  }
            }
          }
        }
      }
      if (king_x < SquareX && king_y == SquareY) {
        for (int k = 1; k < SquareX - king_x; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].iswhite != iswhite
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, SquareX - k, SquareY)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_y == SquareY) {
        for (int k = 1; k < king_x - SquareX; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].iswhite != iswhite
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, SquareX + k, SquareY)) {
                    return true; 
                  }
            }
          }
        }
      }
      return false; 
  }
  
}

class Queen extends Piece {

  Queen(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white); 
    material_value = 9;
    assign_visual(false);  
    letter = (white) ? "q" : "Q";
  }
  
    void assign_visual(boolean highlight) {
      visual = (iswhite) ? whitequeenimg : blackqueenimg; 
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    Bishop local_bishop = new Bishop(SquareX * 100, SquareY * 100, iswhite); 
    Rook local_rook = new Rook(SquareX * 100, SquareY * 100, iswhite); 
    if (local_bishop.is_legal(my_board, for_white, for_black, x, y)) {
    return true; 
    }
    if (local_rook.is_legal(my_board, for_white, for_black, x, y)) {
    return true;
    }
    return false; 
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    Bishop my_bish = new Bishop(SquareX * 100, SquareY * 100, iswhite);
    my_bish.material_value = 9; 
    Rook my_rook = new Rook(SquareX * 100, SquareY * 100, iswhite);
    my_rook.material_value = 9; 
    my_bish.assign_protected_squares(my_board, white_protected, black_protected); 
    my_rook.assign_protected_squares(my_board, white_protected, black_protected); 
  }
  
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
    Bishop my_bish = new Bishop(SquareX * 100, SquareY * 100, iswhite); 
    Rook my_rook = new Rook(SquareX * 100, SquareY * 100, iswhite); 
    if (my_bish.blockable(my_board, for_white, for_black, king_x, king_y)) {
      return true; 
    }
    if (my_rook.blockable(my_board, for_white, for_black, king_x, king_y)) {
      return true; 
    }
    return false; 
  }
}

class King extends Piece { 
  
  King(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white); 
    material_value = 50;
    assign_visual(false); 
    letter = (white) ? "k" : "K"; 
  }
  
   void assign_visual(boolean highlight) {
      visual = (iswhite) ? whitekingimg : blackkingimg; 
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) { 
    if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
  //cannot capture pieces of the same color
  if (my_board[y][x] != null && my_board[y][x].iswhite == iswhite) {
    return false; 
  }
  if (iswhite && for_black[y][x] != null) {
    return false; 
  }
  else if (in_check(for_white, for_black) && iswhite) {
    my_board[SquareY][SquareX] = null; 
  refresh_protected(my_board, for_white, for_black); 
  if (for_black[y][x] != null) {
    my_board[SquareY][SquareX] = this;
    refresh_protected(my_board, for_white, for_black);   
    return false; 
  }
  my_board[SquareY][SquareX] = this; 
  refresh_protected(my_board, for_white, for_black); 
  }
  if (!iswhite && for_white[y][x] != null) {
    return false; 
  }
  else if (in_check(for_white, for_black) && !iswhite) {
    my_board[SquareY][SquareX] = null; 
  refresh_protected(my_board, for_white, for_black); 
  if (for_white[y][x] != null) {
    my_board[SquareY][SquareX] = this;
    refresh_protected(my_board, for_white, for_black);  
    return false; 
  }
  my_board[SquareY][SquareX] = this; 
  refresh_protected(my_board, for_white, for_black); 
  }
  //castling kingside and queenside, fix for protected squares 
  if (y == SquareY && !has_moved) {
    if (x == 6 && (my_board[y][7].letter == "r" || my_board[y][7].letter == "R") 
      && my_board[y][5] == null && my_board[y][6] == null && !my_board[y][7].has_moved && !in_check(for_white, for_black)) {
      if (iswhite && for_black[y][5] == null && for_black[y][6] == null) {
        my_board[y][5] = new Rook(500, my_board[y][7].y_coord, my_board[y][7].iswhite);
        my_board[y][5].has_moved = true;
        my_board[y][7] = null;  
    return true;
      }
      else if (!iswhite && for_white[y][5] == null && for_white[y][6] == null) {
        my_board[y][5] = new Rook(500, my_board[y][7].y_coord, my_board[y][7].iswhite);
        my_board[y][5].has_moved = true;
        my_board[y][7] = null;  
        return true;
      }
    }
    else if (x == SquareX - 2 && (my_board[y][x - 2].letter == "r" || my_board[y][x - 2].letter == "R") 
      && my_board[y][1] == null && my_board[y][2] == null && my_board[y][3] == null && !my_board[y][x-2].has_moved && !in_check(for_white, for_black)) {
      if (iswhite && for_black[y][2] == null && for_black[y][3] == null) {
        my_board[y][3] = new Rook(300, my_board[y][0].y_coord, my_board[y][7].iswhite); 
        my_board[y][3].has_moved = true; 
        my_board[y][0] = null; 
    return true; 
      }
      if (!iswhite && for_white[y][2] == null && for_white[y][3] == null) {
        my_board[y][3] = new Rook(300, my_board[y][0].y_coord, my_board[y][7].iswhite); 
        my_board[y][3].has_moved = true; 
        my_board[y][0] = null; 
        return true; 
      }
    }
  }
  //else can move to any square within 1. 
  if (x == SquareX + 1 || x == SquareX || x == SquareX - 1) {
    if (y == SquareY + 1 || y == SquareY || y == SquareY - 1) {
      return true; 
    }
  }
    }
  return false; 
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    if (iswhite) {
       NewProtected(SquareX, SquareY - 1, this, white_protected); 
       NewProtected(SquareX, SquareY + 1, this, white_protected); 
       NewProtected(SquareX - 1, SquareY, this, white_protected); 
       NewProtected(SquareX + 1, SquareY, this, white_protected); 
       NewProtected(SquareX - 1, SquareY - 1, this, white_protected); 
       NewProtected(SquareX - 1, SquareY + 1, this, white_protected); 
       NewProtected(SquareX + 1, SquareY - 1, this, white_protected); 
       NewProtected(SquareX + 1, SquareY + 1, this, white_protected); 
    }
    else {
      NewProtected(SquareX, SquareY - 1, this, black_protected); 
      NewProtected(SquareX, SquareY + 1, this, black_protected); 
      NewProtected(SquareX - 1, SquareY, this, black_protected); 
      NewProtected(SquareX + 1, SquareY, this, black_protected); 
      NewProtected(SquareX - 1, SquareY - 1, this, black_protected); 
      NewProtected(SquareX - 1, SquareY + 1, this, black_protected); 
      NewProtected(SquareX + 1, SquareY - 1, this, black_protected); 
      NewProtected(SquareX + 1, SquareY + 1, this, black_protected);
    }
  }
  
  boolean in_check(ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
    if (iswhite) {
      if (for_black[SquareY][SquareX] != null) {
         return true;
      }
    }
    else {
      if (for_white[SquareY][SquareX] != null) {
        return true; 
      }
    }
    return false; 
  }
  
  boolean checkmate(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
     if (in_check(for_white, for_black) && num_legal_moves(my_board, for_white, for_black) == 0) 
         { 
           if (iswhite) {
               
             //STORE SOME OBJECTS 
             ProtectedSquare black_square = for_black[SquareY][SquareX];
             ProtectedSquare white_defender = for_white[black_square.primary.defending_piece.SquareY][black_square.primary.defending_piece.SquareX]; 
       
           //IF THERE ARE MULTIPLE PIECES ATTACKING THE KING
           if (black_square.primary.next != null) {
              return true; 
           }
             
             //IF THERE ARE NO WHITE PIECES ATTACKING THE BLACK PIECE GIVING CHECK
             if (white_defender == null) {
               //IF THE CHECK IS NOT BLOCKABLE
               if (!black_square.primary.defending_piece.blockable(my_board, for_white, for_black, this.SquareX, this.SquareY)) {
                 return true; 
               }
             }
             //ELSE IF THE WEAKEST ATTACKER OF THE CHECKING PIECE IS THE KING
             else if (white_defender.primary.defending_piece.material_value == 50) {
               //ENSURE THE BLACK PIECE IS DEFENDED
               if (for_black[black_square.primary.defending_piece.SquareY][black_square.primary.defending_piece.SquareX] != null) {
                 return true;
               }
             }
             //ELSE IF A WHITE PIECE ATTACKING THE CHECKING PIECE CANNOT LEGALLY CAPTURE
             else {
               SquareDefender stepper = white_defender.primary; 
               while (stepper != null) {
                 if (!stepper.defending_piece.is_legal(my_board, for_white, for_black, black_square.primary.defending_piece.SquareX, black_square.primary.defending_piece.SquareY)) {
                   stepper = stepper.next;
                 }
                 else {
                   return false; 
                 } 
               }
               return true; 
             }
           }
           
           //if black king and attacking piece cannot be captured, 
           if (!iswhite) 
           {
             
             //STORE SOME OBJECTS 
             ProtectedSquare white_square = for_white[SquareY][SquareX]; 
             ProtectedSquare black_defender = for_black[white_square.primary.defending_piece.SquareY][white_square.primary.defending_piece.SquareX];
       
       //IF THERE ARE MULTIPLE PIECES ATTACKING THE KING
      if (white_square.primary.next != null) {
        return true; 
      }
             
             //IF THERE ARE NO BLACK PIECES ATTACKING THE WHITE PIECE GIVING CHECK
             if (black_defender == null) {
               //IF THE CHECK IS NOT BLOCKABLE
               if (!white_square.primary.defending_piece.blockable(my_board, for_white, for_black, this.SquareX, this.SquareY)) {
                 return true; 
               }
             }
             //ELSE IF THE WEAKEST ATTACKER OF THE CHECKING PIECE IS THE KING
             else if (black_defender.primary.defending_piece.material_value == 50) {
               //ENSURE THE WHITE PIECE IS DEFENDED
               if (for_white[white_square.primary.defending_piece.SquareY][white_square.primary.defending_piece.SquareX] != null) {
                 return true; 
               } 
             }
             //ELSE IF A BLACK PIECE ATTACKING THE CHECKING PIECE CANNOT LEGALLY CAPTURE
             else {
               SquareDefender stepper = black_defender.primary;
                while (stepper != null) {
                 if (!stepper.defending_piece.is_legal(my_board, for_white, for_black, white_square.primary.defending_piece.SquareX, white_square.primary.defending_piece.SquareY)) {
                   stepper = stepper.next;
                 }
                 else {
                   return false; 
                 } 
               }
               return true; 
             }
           }
         }
     return false; 
  }
  
  int num_legal_moves(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
    int legal_moves = 8; 
    if (!is_legal(my_board, for_white, for_black, this.SquareX - 1, this.SquareY - 1)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX, this.SquareY - 1)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX + 1, this.SquareY - 1)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX + 1, this.SquareY)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX + 1, this.SquareY + 1)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX, this.SquareY + 1)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX - 1, this.SquareY + 1)) {
      legal_moves--; 
    }
    if (!is_legal(my_board, for_white, for_black, this.SquareX - 1, this.SquareY)) {
      legal_moves--; 
    }
    return legal_moves; 
  }
}

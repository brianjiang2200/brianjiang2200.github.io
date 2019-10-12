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
  //IMAGE FOR WHITE PIECE
  PImage white_image;
  //IMAGE FOR BLACK PIECE
  PImage black_image;
  //LETTER REPRESENTING WHITE PIECE
  String white_letter;
  //LETTER REPRESENTING BLACK PIECE
  String black_letter;     

  //CONSTRUCTOR
  Piece(int xpos, int ypos, boolean white) {
  x_coord = xpos; 
  y_coord = ypos;
  SquareX = xpos/100; 
  SquareY = ypos/100; 
  iswhite = white;  
  }
  
  //RETURN MATERIAL VALUE
  int get_material_value() {
    return this.material_value; 
  }
  
  //RETURN X COORDINATE
  int get_x_pos() {
  return this.x_coord;
  }
  
  //RETURN Y COORDINATE
  int get_y_pos() {
  return this.y_coord; 
  }
  
  //RETURN COLOUR
  boolean get_color() {
  return this.iswhite; 
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
    if (this.get_color() && copy_white_king.in_check(whites_squares, blacks_squares)) {
        return false; 
    }
	  else if (!this.get_color() && copy_black_king.in_check(whites_squares, blacks_squares)) {
		  return false; 
	  }
    return true;
  }
  
  //RETURN LETTER
  String get_letter() {
    return (iswhite) ? white_letter : black_letter; 
  }
  
  //DISPLAY PIECE
  void display() {
    if (this.iswhite) {
      image(this.white_image, this.x_coord, this.y_coord, piecedim, piecedim); 
    }
    else {
      image(this.black_image, this.x_coord, this.y_coord, piecedim, piecedim); 
    }
  }

  //ASSIGN PROTECTED SQUARES
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
     //overridden by subclasses
  }
  
}
 

class Pawn extends Piece { 

  Pawn(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white);
    material_value = 1;
    white_image = whitepawnimg; 
    black_image = blackpawnimg;
    white_letter = "p"; 
    black_letter = "P";
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
   
    if (this.get_color()) {
	
      //FORWARD MOVEMENT FOR WHITE PAWNS
      if (x == this.SquareX && my_board[this.SquareY - 1][x] == null) { 
			  if (y == this.SquareY - 1) {
			    return this.verify_not_check(my_board, y, x);
			  }
        if (this.SquareY == 6 && y == this.SquareY - 2 && my_board[this.SquareY - 2][x] == null) {
			    return this.verify_not_check(my_board, y, x);
		    }
      }
	  
      if (y == this.SquareY - 1) {
        //CAPTURING TO THE LEFT
        if (x == this.SquareX - 1 && my_board[this.SquareY - 1][x] != null && my_board[this.SquareY - 1][x].get_color() == false) {
          return this.verify_not_check(my_board, y, x); 
        }
        //CAPTURING TO THE RIGHT
        else if (x == this.SquareX + 1 && my_board[this.SquareY - 1][x] != null && my_board[this.SquareY - 1][x].get_color() == false) {
           return this.verify_not_check(my_board, y, x);
        }
        //EN PASSANT TO THE LEFT
        else if (x == this.SquareX - 1 && my_board[this.SquareY][x] != null && my_board[this.SquareY][x].en_passant) {
          Piece[][] local_board = duplicate_board(my_board);
		      ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
		      ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
          local_board[this.SquareY][this.SquareX].SquareY = y;
          local_board[this.SquareY][this.SquareX].SquareX = x; 
          local_board[y][x] = this; 
          local_board[this.SquareY][this.SquareX] = null;
          local_board[y + 1][x] = null;
		      duplicate_protected_squares(local_board, whites_squares, blacks_squares);
          if (copy_white_king.in_check(whites_squares, blacks_squares)) {
            return false; 
          }
          return true; 
        }
        //EN PASSANT TO THE RIGHT
        else if (x == this.SquareX + 1 && my_board[this.SquareY][x] != null && my_board[this.SquareY][x].en_passant) {
          Piece[][] local_board = duplicate_board(my_board);
		      ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
		      ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
          local_board[this.SquareY][this.SquareX].SquareY = y;
          local_board[this.SquareY][this.SquareX].SquareX = x; 
          local_board[y][x] = this; 
          local_board[this.SquareY][this.SquareX] = null; 
          local_board[y + 1][x] = null;
		      duplicate_protected_squares(local_board, whites_squares, blacks_squares);
          if (copy_white_king.in_check(whites_squares, blacks_squares)) {
            return false; 
          }
          return true; 
        }
       }
      }
      
    else if (!this.get_color()) {
      //forward movement for black pawns
      if (x == this.SquareX && my_board[this.SquareY + 1][x] == null) {
         if (y == this.SquareY + 1) {
			      return this.verify_not_check(my_board, y, x);
         }
         if (this.SquareY == 1 && y == this.SquareY + 2 && piece_board[this.SquareY + 2][x] == null) {
           return this.verify_not_check(my_board, y, x);
         }
       }
      if (y == this.SquareY + 1) {
        //capturing to the left
        if (x == this.SquareX - 1 && my_board[this.SquareY + 1][x] != null && my_board[this.SquareY + 1][x].get_color() == true) {
          return this.verify_not_check(my_board, y, x); 
        }
        //capturing to the right
        else if (x == this.SquareX + 1 && my_board[this.SquareY + 1][x] != null && my_board[this.SquareY + 1][x].get_color() == true) {
          return this.verify_not_check(my_board, y, x); 
        }
        //en passant to the left
        else if (x == this.SquareX - 1 && my_board[this.SquareY][x] != null && my_board[this.SquareY][x].en_passant) {
           Piece[][] local_board = duplicate_board(my_board);
		       ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
		       ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
           local_board[this.SquareY][this.SquareX].SquareY = y;
           local_board[this.SquareY][this.SquareX].SquareX = x; 
           local_board[y][x] = this; 
           local_board[this.SquareY][this.SquareX] = null;
		       duplicate_protected_squares(local_board, whites_squares, blacks_squares);		  
           if (copy_black_king.in_check(whites_squares, blacks_squares)) {
             return false; 
           }
           return true;
        }
        //en passant to the right
        else if (x == this.SquareX + 1 && my_board[this.SquareY][x] != null && my_board[this.SquareY][x].en_passant) {
           Piece[][] local_board = duplicate_board(my_board);
		       ProtectedSquare [][] whites_squares = new ProtectedSquare[8][8]; 
		       ProtectedSquare [][] blacks_squares = new ProtectedSquare[8][8]; 
          local_board[this.SquareY][this.SquareX].SquareY = y;
          local_board[this.SquareY][this.SquareX].SquareX = x; 
          local_board[y][x] = this; 
          local_board[this.SquareY][this.SquareX] = null;
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
     if (this.SquareY != 0 && this.SquareY != 7) {
      if (this.get_color()) {
        if (this.SquareX > 0) {
          new_white_protected(this.SquareX - 1, this.SquareY - 1, this, white_protected);
        }
        if (this.SquareX < 7) {
          new_white_protected(this.SquareX + 1, this.SquareY - 1, this, white_protected); 
        }
      }
      else {
        if (this.SquareX > 0) {
          new_black_protected(this.SquareX - 1, this.SquareY + 1, this, black_protected); 
        }
        if (this.SquareX < 7) {
          new_black_protected(this.SquareX + 1, this.SquareY + 1, this, black_protected); 
        }
      }
    }
  }
  
}

class Knight extends Piece {
  
  Knight(int xpos, int ypos, boolean white) {
     super(xpos, ypos, white); 
     material_value = 3;
     white_image = whiteknightimg; 
     black_image = blackknightimg;
     white_letter = "n";
     black_letter = "N";
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
       if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
		if (my_board[y][x] != null && my_board[y][x].get_color() == this.get_color()) {
			return false; 
		} 
		if (x == this.SquareX + 2 || x == this.SquareX - 2) {
			if (y == this.SquareY + 1 || y == this.SquareY - 1) {
				return this.verify_not_check(my_board, y, x);
			}
		}
		if (x == this.SquareX + 1 || x == this.SquareX - 1) {
			if (y == this.SquareY + 2 || y == this.SquareY - 2) {
				return this.verify_not_check(my_board, y, x);
			}
		} 
    }
    return false;  
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    if (this.get_color()) {
      new_white_protected(this.SquareX - 2, this.SquareY - 1, this, white_protected); 
      new_white_protected(this.SquareX - 2, this.SquareY + 1, this, white_protected); 
      new_white_protected(this.SquareX - 1, this.SquareY - 2, this, white_protected); 
      new_white_protected(this.SquareX - 1, this.SquareY + 2, this, white_protected); 
      new_white_protected(this.SquareX + 1, this.SquareY - 2, this, white_protected); 
      new_white_protected(this.SquareX + 1, this.SquareY + 2, this, white_protected); 
      new_white_protected(this.SquareX + 2, this.SquareY - 1, this, white_protected); 
      new_white_protected(this.SquareX + 2, this.SquareY + 1, this, white_protected); 
    }
    else {
      new_black_protected(this.SquareX - 2, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX - 2, this.SquareY + 1, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY - 2, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY + 2, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY - 2, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY + 2, this, black_protected); 
      new_black_protected(this.SquareX + 2, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX + 2, this.SquareY + 1, this, black_protected);
    }
  }

}

class Bishop extends Piece {
  
  Bishop(int xpos, int ypos, boolean white) {
    super(xpos, ypos, white); 
    material_value = 3; 
    white_image = whitebishopimg; 
    black_image = blackbishopimg; 
    white_letter = "b"; 
    black_letter = "B";
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
	
	//this already checks if a piece lands on the same square as itself. 
	if (my_board[y][x] != null && my_board[y][x].get_color() == this.get_color()) {
		return false; 
	}
	if (abs(y - this.SquareY) == abs(x - this.SquareX)) {
	
		if (y > this.SquareY && x > this.SquareX) {
			for (int z = 1; z < y - this.SquareY; ++z) {
				if (my_board[this.SquareY + z][this.SquareX + z] != null) {
					return false; 
				}
			}
			return this.verify_not_check(my_board, y, x);
		}
	
		else if (y > this.SquareY && x < this.SquareX) {
			for (int z = 1; z < y - this.SquareY; ++z) {
				if (my_board[this.SquareY + z][this.SquareX - z] != null) {
					return false; 
				}
			}
			return this.verify_not_check(my_board, y, x);
		}
		
		else if (y < this.SquareY && x > this.SquareX) {
			for (int z = 1; z < x - this.SquareX; ++z) {
				if (my_board[this.SquareY - z][this.SquareX + z] != null) {
					return false; 
				}
			}
			return this.verify_not_check(my_board, y, x);
		}
		
		else {
			for (int z = 1; z < this.SquareX - x; ++z) {
				if (my_board[this.SquareY - z][this.SquareX - z] != null) {
					return false;
				}
			}
			return this.verify_not_check(my_board, y, x);
		}
		
	}
    }
    return false; 
  }

  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    int z;
    if (this.get_color()) {
       new_white_protected(this.SquareX - 1, this.SquareY - 1, this, white_protected); 
       new_white_protected(this.SquareX - 1, this.SquareY + 1, this, white_protected);
       new_white_protected(this.SquareX + 1, this.SquareY - 1, this, white_protected); 
       new_white_protected(this.SquareX + 1, this.SquareY + 1, this, white_protected); 
          z = 1;
          while (check_null(my_board, this.SquareX - z, this.SquareY - z)) {
            new_white_protected(this.SquareX - z - 1, this.SquareY - z - 1, this, white_protected);
            z++;
          }
          z = 1;
          while (check_null(my_board, this.SquareX - z, this.SquareY + z)) {
            new_white_protected(this.SquareX - z - 1, this.SquareY + z + 1, this, white_protected);
            z++;
          }
          z = 1;
          while (check_null(my_board, this.SquareX + z, this.SquareY - z)) {
            new_white_protected(this.SquareX + z + 1, this.SquareY - z - 1, this, white_protected);
            z++;
          }
          z = 1;
          while (check_null(my_board, this.SquareX + z, this.SquareY + z)) {
            new_white_protected(this.SquareX + z + 1, this.SquareY + z + 1, this, white_protected);
            z++;
          }
    }
    else {
      new_black_protected(this.SquareX - 1, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY + 1, this, black_protected);
      new_black_protected(this.SquareX + 1, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY + 1, this, black_protected);
        z = 1;
        while (check_null(my_board, this.SquareX - z, this.SquareY - z)) {
          new_black_protected(this.SquareX - z - 1, this.SquareY - z - 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, this.SquareX - z, this.SquareY + z)) {
          new_black_protected(this.SquareX - z - 1, this.SquareY + z + 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, this.SquareX + z, this.SquareY - z)) {
          new_black_protected(this.SquareX + z + 1, this.SquareY - z - 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, this.SquareX + z, this.SquareY + z)) {
          new_black_protected(this.SquareX + z + 1, this.SquareY + z + 1, this, black_protected);
          z++;
        }
    }
  }
  
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
      if (king_x < this.SquareX && king_y < this.SquareY) {
        for (int k = 1; k < this.SquareY - king_y; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].get_color() != this.get_color()
                  && my_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX - k, this.SquareY - k)) {
                    return true; 
                  }
            }
          }
        }
      }
      if (king_x < this.SquareX && king_y > this.SquareY) {
        for (int k = 1; k < this.SquareX - king_x; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].get_color() != this.get_color() 
                  && my_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX - k, this.SquareY + k)) {
                    return true; 
                  }
            }
          }
        }
      }
      if (king_x > this.SquareX && king_y < this.SquareY) {
        for (int k = 1; k < this.SquareY - king_y; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].get_color() != this.get_color() 
                  && my_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX + k, this.SquareY - k)) {
                    return true; 
                  }
            }
          }
        }
      }
      if (king_x > this.SquareX && king_y > this.SquareY) {
        for (int k = 1; k < king_y - this.SquareY; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (my_board[a][b] != null && my_board[a][b].get_color() != this.get_color()
                  && my_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX + k, this.SquareY + k)) {
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
    white_image = whiterookimg; 
    black_image = blackrookimg;
    white_letter = "r"; 
    black_letter = "R";
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
      if (my_board[y][x] != null && my_board[y][x].get_color() == this.get_color()) {
        return false; 
      } 
	    if (x == this.SquareX && y > this.SquareY) {
		    for (int z = this.SquareY + 1; z < y; z++) {
			    if (my_board[z][x] != null) { 
				    return false; 
			    }
		    }
			return this.verify_not_check(my_board, y, x);
	    }
	    else if (x == this.SquareX && y < this.SquareY) {
		    for (int z = this.SquareY - 1; z > y; z--) {
			    if (my_board[z][x] != null) {
				    return false;
			    }
		    }
			return this.verify_not_check(my_board, y, x);
	    }
      else if (y == this.SquareY && x > this.SquareX) {
        for (int z = this.SquareX + 1; z < x; z++) {
          if (my_board[y][z] != null) {
            return false; 
          }
        }
			return this.verify_not_check(my_board, y, x);
        }
      else if (y == this.SquareY) {
        for (int z = this.SquareX - 1; z > x; z--) {
          if (my_board[y][z] != null) {
            return false;
          }
        }
			return this.verify_not_check(my_board, y, x);
      }
    }
    return false; 
  }

  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    int z; 
    if (this.get_color()) {
      new_white_protected(this.SquareX, this.SquareY + 1, this, white_protected); 
      new_white_protected(this.SquareX, this.SquareY - 1, this, white_protected); 
      new_white_protected(this.SquareX + 1, this.SquareY, this, white_protected); 
      new_white_protected(this.SquareX - 1, this.SquareY, this, white_protected);
        z = 1;
        while (check_null(my_board, this.SquareX + z, this.SquareY)) {
          new_white_protected(this.SquareX + z + 1, this.SquareY, this, white_protected); 
          z++;
        }
        z = 1; 
        while (check_null(my_board, this.SquareX - z, this.SquareY)) {
          new_white_protected(this.SquareX - z - 1, this.SquareY, this, white_protected);
          z++;
        }
        z = 1; 
        while (check_null(my_board, this.SquareX, this.SquareY + z)) {
          new_white_protected(this.SquareX, this.SquareY + z + 1, this, white_protected);
          z++;
        }
        z = 1; 
        while (check_null(my_board, this.SquareX, this.SquareY - z)) {
          new_white_protected(this.SquareX, this.SquareY - z - 1, this, white_protected);
          z++;
        }
    }
    else {
      new_black_protected(this.SquareX, this.SquareY + 1, this, black_protected); 
      new_black_protected(this.SquareX, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY, this, black_protected);
        z = 1;
        while (check_null(my_board, this.SquareX + z, this.SquareY)) {
          new_black_protected(this.SquareX + z + 1, this.SquareY, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, this.SquareX - z, this.SquareY)) {
          new_black_protected(this.SquareX - z -1, this.SquareY, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, this.SquareX, this.SquareY + z)) {
          new_black_protected(this.SquareX, this.SquareY + z + 1, this, black_protected);
          z++;
        }
        z = 1;
        while (check_null(my_board, this.SquareX, this.SquareY - z)) {
          new_black_protected(this.SquareX, this.SquareY - z - 1, this, black_protected);
          z++;
        }
    }
  }
  
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
    if (king_x == this.SquareX && king_y < this.SquareY) {
        for (int k = 1; k < this.SquareY - king_y; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].get_color() != this.get_color()
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX, this.SquareY - k)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_x == this.SquareX) {
        for (int k = 1; k < king_y - this.SquareY; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].get_color() != this.get_color()
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX, this.SquareY + k)) {
                    return true; 
                  }
            }
          }
        }
      }
      if (king_x < this.SquareX && king_y == this.SquareY) {
        for (int k = 1; k < this.SquareX - king_x; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].get_color() != this.get_color()
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX - k, this.SquareY)) {
                    return true; 
                  }
            }
          }
        }
      }
      else if (king_y == this.SquareY) {
        for (int k = 1; k < king_x - this.SquareX; ++k) {
          for (int a = 0; a < 8; ++a) {
            for (int b = 0; b < 8; ++b) {
              if (piece_board[a][b] != null && piece_board[a][b].get_color() != this.get_color()
                  && piece_board[a][b].is_legal(my_board, for_white, for_black, this.SquareX + k, this.SquareY)) {
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
    white_image = whitequeenimg; 
    black_image = blackqueenimg; 
    white_letter = "q"; 
    black_letter = "Q";
  }
  
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) {
    Bishop local_bishop = new Bishop(this.SquareX * 100, this.SquareY * 100, this.get_color()); 
    Rook local_rook = new Rook(this.SquareX * 100, this.SquareY * 100, this.get_color()); 
    if (local_bishop.is_legal(my_board, for_white, for_black, x, y)) {
		return true; 
    }
    if (local_rook.is_legal(my_board, for_white, for_black, x, y)) {
		return true;
    }
    return false; 
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    Bishop my_bish = new Bishop(this.SquareX * 100, this.SquareY * 100, this.get_color());
    my_bish.material_value = 9; 
    Rook my_rook = new Rook(this.SquareX * 100, this.SquareY * 100, this.get_color());
    my_rook.material_value = 9; 
    my_bish.assign_protected_squares(my_board, white_protected, black_protected); 
    my_rook.assign_protected_squares(my_board, white_protected, black_protected); 
  }
  
  boolean blockable(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int king_x, int king_y) {
    Bishop my_bish = new Bishop(this.SquareX * 100, this.SquareY * 100, this.get_color()); 
    Rook my_rook = new Rook(this.SquareX * 100, this.SquareY * 100, this.get_color()); 
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
    white_image = whitekingimg; 
    black_image = blackkingimg;
    white_letter = "k"; 
    black_letter = "K";
  }
  boolean is_legal(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][], int x, int y) { 
    if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
	//cannot capture pieces of the same color
	if (my_board[y][x] != null && my_board[y][x].get_color() == this.get_color()) {
		return false; 
	}
  if (this.get_color() && for_black[y][x] != null) {
    return false; 
  }
  else if (this.in_check(for_white, for_black) && this.get_color()) {
    my_board[this.SquareY][this.SquareX] = null; 
	refresh_protected(my_board, for_white, for_black); 
	if (for_black[y][x] != null) {
		my_board[this.SquareY][this.SquareX] = this;
		refresh_protected(my_board, for_white, for_black);   
		return false; 
	}
	my_board[this.SquareY][this.SquareX] = this; 
	refresh_protected(my_board, for_white, for_black); 
  }
  if (!this.get_color() && for_white[y][x] != null) {
    return false; 
  }
  else if (this.in_check(for_white, for_black) && !this.get_color()) {
    my_board[this.SquareY][this.SquareX] = null; 
	refresh_protected(my_board, for_white, for_black); 
	if (for_white[y][x] != null) {
		my_board[this.SquareY][this.SquareX] = this;
		refresh_protected(my_board, for_white, for_black);  
		return false; 
	}
	my_board[this.SquareY][this.SquareX] = this; 
	refresh_protected(my_board, for_white, for_black); 
  }
	//castling kingside and queenside, fix for protected squares 
	if (y == this.SquareY && !this.has_moved) {
		if (x == 6 && (my_board[y][7].get_letter() == "r" || my_board[y][7].get_letter() == "R") 
			&& my_board[y][5] == null && my_board[y][6] == null && !my_board[y][7].has_moved && !this.in_check(for_white, for_black)) {
      if (this.get_color() && for_black[y][5] == null && for_black[y][6] == null) {
        my_board[y][5] = new Rook(500, my_board[y][7].y_coord, my_board[y][7].get_color());
        my_board[y][5].has_moved = true;
        my_board[y][7] = null;  
		return true;
      }
      else if (!this.get_color() && for_white[y][5] == null && for_white[y][6] == null) {
        my_board[y][5] = new Rook(500, my_board[y][7].y_coord, my_board[y][7].get_color());
        my_board[y][5].has_moved = true;
        my_board[y][7] = null;  
        return true;
      }
		}
		else if (x == this.SquareX - 2 && (my_board[y][x - 2].get_letter() == "r" || my_board[y][x - 2].get_letter() == "R") 
			&& my_board[y][1] == null && my_board[y][2] == null && my_board[y][3] == null && !my_board[y][x-2].has_moved && !this.in_check(for_white, for_black)) {
      if (this.get_color() && for_black[y][2] == null && for_black[y][3] == null) {
        my_board[y][3] = new Rook(300, my_board[y][0].y_coord, my_board[y][7].get_color()); 
        my_board[y][3].has_moved = true; 
        my_board[y][0] = null; 
		return true; 
      }
      if (!this.get_color() && for_white[y][2] == null && for_white[y][3] == null) {
        my_board[y][3] = new Rook(300, my_board[y][0].y_coord, my_board[y][7].get_color()); 
        my_board[y][3].has_moved = true; 
        my_board[y][0] = null; 
        return true; 
      }
		}
	}
	//else can move to any square within 1. 
	if (x == this.SquareX + 1 || x == this.SquareX || x == this.SquareX - 1) {
		if (y == this.SquareY + 1 || y == this.SquareY || y == this.SquareY - 1) {
			return true; 
		}
	}
    }
  return false; 
  }
  
  void assign_protected_squares(Piece my_board[][], ProtectedSquare white_protected[][], ProtectedSquare black_protected[][]) {
    if (this.get_color()) {
       new_white_protected(this.SquareX, this.SquareY - 1, this, white_protected); 
       new_white_protected(this.SquareX, this.SquareY + 1, this, white_protected); 
       new_white_protected(this.SquareX - 1, this.SquareY, this, white_protected); 
       new_white_protected(this.SquareX + 1, this.SquareY, this, white_protected); 
       new_white_protected(this.SquareX - 1, this.SquareY - 1, this, white_protected); 
       new_white_protected(this.SquareX - 1, this.SquareY + 1, this, white_protected); 
       new_white_protected(this.SquareX + 1, this.SquareY - 1, this, white_protected); 
       new_white_protected(this.SquareX + 1, this.SquareY + 1, this, white_protected); 
    }
    else {
      new_black_protected(this.SquareX, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX, this.SquareY + 1, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX - 1, this.SquareY + 1, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY - 1, this, black_protected); 
      new_black_protected(this.SquareX + 1, this.SquareY + 1, this, black_protected);
    }
  }
  
  boolean in_check(ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
    if (this.get_color()) {
      if (for_black[this.SquareY][this.SquareX] != null) {
         return true;
      }
    }
    else {
      if (for_white[this.SquareY][this.SquareX] != null) {
        return true; 
      }
    }
    return false; 
  }
  
  boolean checkmate(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
     if (this.in_check(for_white, for_black) && this.num_legal_moves(my_board, for_white, for_black) == 0) 
         { 
           if (this.get_color()) {
               
             //STORE SOME OBJECTS 
             ProtectedSquare black_square = for_black[this.SquareY][this.SquareX];
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
             else if (white_defender.primary.defending_piece.get_material_value() == 50) {
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
           if (!this.get_color()) 
           {
             
             //STORE SOME OBJECTS 
             ProtectedSquare white_square = for_white[this.SquareY][this.SquareX]; 
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
             else if (black_defender.primary.defending_piece.get_material_value() == 50) {
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
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX - 1, this.SquareY - 1)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX, this.SquareY - 1)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX + 1, this.SquareY - 1)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX + 1, this.SquareY)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX + 1, this.SquareY + 1)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX, this.SquareY + 1)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX - 1, this.SquareY + 1)) {
      legal_moves--; 
    }
    if (!this.is_legal(my_board, for_white, for_black, this.SquareX - 1, this.SquareY)) {
      legal_moves--; 
    }
    return legal_moves; 
  }
}

//DEFENDER NODE CLASS TO BE USED IN THE PROTECTEDSQUARE CLASS
class SquareDefender {
	Piece defending_piece; 
	SquareDefender next; 
	
	SquareDefender (Piece my_piece) {
		this.defending_piece = my_piece; 
		this.next = null; 
	}
}

//PROTECTED SQUARE CLASS
class ProtectedSquare {
  int SquareX; 
  int SquareY; 
  SquareDefender primary; 
  
  ProtectedSquare (int x, int y, Piece my_piece) {
    this.SquareX = x; 
    this.SquareY = y; 
    this.primary = new SquareDefender(my_piece);
  }
  
  void add_defender(Piece new_defender) {
	if (this.primary == null) {
		this.primary = new SquareDefender(new_defender); 
	}
	else {
		SquareDefender stepper = this.primary; 
		while (stepper.next != null) {
			stepper = stepper.next; 
		}
		stepper.next = new SquareDefender(new_defender); 
	}
  }
  
  //RETURNS THE NUMBER OF DEFENDERS FOR ONE SIDE ON THIS SQUARE
  int get_defender_count() {
	  int count = 0; 
	  SquareDefender stepper = this.primary;
	  while (stepper != null) {
		  count++; 
		stepper = stepper.next; 
	  }
    return count; 
  }
  
  //RETURNS THE PIECE AT THE SPECIFIED INDEX OF THE LIST
  Piece get_defender_at_index(int index_no) {
	if (this.primary == null) {
		return null;
	}
	SquareDefender stepper = this.primary; 	
	while (index_no > 0) {
		stepper = stepper.next; 
		index_no--; 
	}
	return stepper.defending_piece;
  }
  
  //SORTS THE LIST
  void insertion_sort() {
	//IF PRIMARY IS NOT NULL
	if (this.primary != null) {
		//STEPPER GETS PRIMARY
		SquareDefender stepper = this.primary;
		//WHILE STEPPER.NEXT IS NOT NULL
		while (stepper.next != null) {
			//IF THE NEXT PIECE HAS LOWER MATERIAL VALUE THAN THE CURRENT
			if (stepper.next.defending_piece.get_material_value() < stepper.defending_piece.get_material_value()) {
				//STORE THE NEXT PIECE
				SquareDefender my_node = stepper.next;
				//LET THE NEXT PIECE TO THE CURRENT ONE BE THE ONE AFTER
				stepper.next = stepper.next.next;
				//SECONDARY STEPPER IS INITIALIZED TO PRIMARY
				SquareDefender new_stepper = this.primary;
				//IF NEW NODE REPLACES PRIMARY
				if (my_node.defending_piece.get_material_value() < primary.defending_piece.get_material_value()) {
					my_node.next = primary; 
					primary = my_node; 
				}
				else {
					//WHILE MY NODE'S PIECE IS OF GREATER VALUE THAN THE NEXT,
					while (my_node.defending_piece.get_material_value() > new_stepper.next.defending_piece.get_material_value()) {
						//SECONDARY STEPPER GETS THAT PIECE
						new_stepper = new_stepper.next; 
					}
					my_node.next = new_stepper.next; 
					new_stepper.next = my_node; 
				}
			}
			//ELSE CONDITION IS IMPORTANT OTHERWISE SORT WOULD SKIP OVER CURRENT NODE THAT MAY NOT BE SORTED
			else {
				stepper = stepper.next;
			}
		}
	}
  }
  
}


class MoveRecord {
  //move stored at this point
  Piece[][] stored_position;
  //Move Number 
  int move_num;
  //Side to Move
  boolean to_move;
  //piece_captured
  boolean piece_captured; 
  //Notation elements
  boolean check; 
  String notation_piece;
  String previous_x;
  int previous_y; 
  String notation_col; 
  int notation_row;
  String promotion_piece = "";
  String equals_sign = "";
  String full_move; 
  MoveRecord next;
  MoveRecord prev; 
  
  MoveRecord (Piece my_piece, Piece new_pos[][], int prev_x, int prev_y, int move_no, boolean capture, boolean is_check) {
    this.stored_position = duplicate_board(new_pos); 
    this.to_move = my_piece.get_color();
    this.move_num = move_no;
    this.notation_piece = (my_piece.get_material_value() == 1) ? "" : my_piece.get_letter().toUpperCase(); 
    switch (prev_x) {
      case 0: 
        this.previous_x = "a";
        break;
      case 1:
        this.previous_x = "b";
        break;
      case 2: 
        this.previous_x = "c";
        break;
      case 3: 
        this.previous_x = "d";
        break;
      case 4: 
        this.previous_x = "e";
        break;
      case 5: 
        this.previous_x = "f";
        break;
      case 6: 
        this.previous_x = "g";
        break;
      case 7: 
        this.previous_x = "h";
        break;
      default: 
        this.previous_x = "?"; 
    }
    this.previous_y = 8 - prev_y; 
    this.notation_row = 8 - my_piece.SquareY; 
    switch (my_piece.SquareX) {
      case 0: 
        this.notation_col = "a";
        break;
      case 1: 
        this.notation_col = "b";
        break;
      case 2:
        this.notation_col = "c";
        break;
      case 3: 
        this.notation_col = "d";
        break;
      case 4: 
        this.notation_col = "e";
        break;
      case 5: 
        this.notation_col = "f";
        break;
      case 6: 
        this.notation_col = "g";
        break;
      case 7: 
        this.notation_col = "h";
        break;
      default: 
        this.notation_col = "?"; 
    }
    this.next = null;
    this.prev = null;
    this.piece_captured = capture;
    this.check = is_check;
    this.full_move = generate_move(); 
  }
  
  String generate_move() {
    if (this.notation_piece.equals("K") && previous_x.equals("e") && notation_col.equals("g")) {
           if (check) {
             return (color_won != 0) ? str(move_num) + ". " + "O-O" + "#" : str(move_num) + ". " + "O-O" + "+";
           }
           else {
             return str(move_num) + ". " + "O-O"; 
           }
       }
       else if (notation_piece.equals("K") && previous_x.equals("e") && notation_col.equals("c")) {
            if (check) {
             return (color_won != 0) ? str(move_num) + ". " + "O-O-O" + "#" : str(move_num) + ". " + "O-O-O" + "+";
           }
           else {
             return str(move_num) + ". " + "O-O-O";
           } 
       }
    else if (piece_captured) {
      if (color_won != 0 && this == main_move_list.tail) {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + " x " + notation_col + notation_row + equals_sign + promotion_piece + "#"; 
      }
      else if (check) {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + " x " + notation_col + notation_row + equals_sign + promotion_piece + "+";
      }
      else {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + " x " + notation_col + notation_row + equals_sign + promotion_piece;
      }
    }
    else {
      if (color_won != 0 && this == main_move_list.tail) {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + " - " + notation_col + notation_row + equals_sign + promotion_piece + "#"; 
      }
      else if (check) {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + " - " + notation_col + notation_row + equals_sign + promotion_piece + "+";
      }
      else {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + " - " + notation_col + notation_row + equals_sign + promotion_piece;
      }
    }
  }
  
   void print_move(int x_pos, int y_pos) {
     textSize(27); 
     fill(255);
     text(full_move, x_pos, y_pos); 
  } //<>//
}

class MoveList {
  MoveRecord head; 
  MoveRecord tail; 
  
  MoveList() {
    this.head = null; 
    this.tail = null; 
  }
  
  //Adds a move to a move list
  void add_move(MoveRecord my_move) {
    if (this.head == null) {
      this.head = my_move; 
      this.tail = my_move; 
    }
    else {
      this.tail.next = my_move; 
      my_move.prev = this.tail;
      this.tail = my_move; 
    }
  }
  
  //Get a move at Specified Index
  MoveRecord get_move_at_index(int index_no) {
  if (this.head == null) {
    return null;
  }
  MoveRecord stepper = this.head;   
  while (index_no > 0 && stepper != null) {
    stepper = stepper.next; 
    index_no--; 
  }
  if (index_no != 0) {
    println("The move list specified does not contain a move record at the specified index."); 
  }
  return stepper;
  }
}

//CHECK IF X AND Y ARE IN [0,7]
boolean inRange(int x, int y) {
	return (min(x,y,0) == 0 && max(x,y,7) == 7); 
}

//CHECK IF A SQUARE IS EMPTY
boolean check_null(Piece my_board[][], int x, int y) {
  if (inRange(x,y)) {
    if (my_board[y][x] == null) {
      return true;
    }
  }
  return false;
}

//DUPLICATE A BOARD POSITION 
Piece [] [] duplicate_board(Piece curr_board[][]) {
	Piece [] [] copy = new Piece[8][8]; 
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (curr_board[i][k] != null) {
				if (curr_board[i][k].material_value == 1) {
					copy[i][k] = new Pawn(curr_board[i][k].SquareX, curr_board[i][k].SquareY, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].letter == "n" || curr_board[i][k].letter == "N") {
					copy[i][k] = new Knight(curr_board[i][k].SquareX, curr_board[i][k].SquareY, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].letter == "b" || curr_board[i][k].letter == "B") {
					copy[i][k] = new Bishop(curr_board[i][k].SquareX, curr_board[i][k].SquareY, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].material_value == 5) {
					copy[i][k] = new Rook(curr_board[i][k].SquareX, curr_board[i][k].SquareY, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].material_value == 9) {
					copy[i][k] = new Queen(curr_board[i][k].SquareX, curr_board[i][k].SquareY, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].material_value == 50) {
					if (curr_board[i][k].letter == "k") {
						copy_white_king = new King(curr_board[i][k].SquareX, curr_board[i][k].SquareY, true);
						copy[i][k] = copy_white_king; 
					}
					if (curr_board[i][k].letter == "K") {
						copy_black_king = new King(curr_board[i][k].SquareX, curr_board[i][k].SquareY, false);
						copy[i][k] = copy_black_king; 
					}
				}
				if (curr_board[i][k].has_moved) {
					copy[i][k].has_moved = true; 
				}
			}
		}
	}
	return copy; 
} 

//Empty a Board
void emptyBoard(Piece my_board[][]) {
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			my_board[i][k] = null; 
		}
	}
}

//Duplicate ProtectedSquare Array 
void duplicate_protected_squares(Piece curr_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (curr_board[i][k] != null) {
				curr_board[i][k].assign_protected_squares(curr_board, for_white, for_black);
			}
		}
	}
}

boolean piece_on_board(Piece my_board[][]) {
  for (int i = 0; i < 8; ++i) {
    for (int k = 0; k < 8; ++k) {
      if (my_board[i][k] != null && my_board[i][k].material_value == 3) {
        return true; 
      }
    }
  }
  return false; 
}

//Count Material
int CountMaterial(Piece my_board[][], boolean piececolor) {
	int Material = 0; 
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (my_board[i][k] != null && my_board[i][k].iswhite == piececolor) {
        			Material += my_board[i][k].material_value;  
			}
		}
	}
	return Material; 
}

//Display Purposes: Norm a value from default width/height to current width/height
float Xnorm(int initX) {
  return map(initX, 0, 1400, 0, width); 
}

float Ynorm(int initY) {
  return map(initY, 0, 900, 0, height); 
}

float invXNorm(int scaledX) {
  return map(scaledX, 0, width, 0, 1400);
}

float invYNorm(int scaledY) {
  return map(scaledY, 0, height, 0, 900); 
}

//CHECK IF A SQUARE IS EMPTY
boolean check_null(Piece my_board[][], int x, int y) {
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
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
					copy[i][k] = new Pawn(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].letter == "n" || curr_board[i][k].letter == "N") {
					copy[i][k] = new Knight(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].letter == "b" || curr_board[i][k].letter == "B") {
					copy[i][k] = new Bishop(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].material_value == 5) {
					copy[i][k] = new Rook(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].material_value == 9) {
					copy[i][k] = new Queen(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].iswhite);
				}
				else if (curr_board[i][k].material_value == 50) {
					if (curr_board[i][k].letter == "k") {
						copy_white_king = new King(curr_board[i][k].x_coord, curr_board[i][k].y_coord, true);
						copy[i][k] = copy_white_king; 
					}
					if (curr_board[i][k].letter == "K") {
						copy_black_king = new King(curr_board[i][k].x_coord, curr_board[i][k].y_coord, false);
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
int CountMaterial(Piece my_board[][], boolean color) {
	int Material = 0; 
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (my_board[i][k] != null && my_board[i][k].iswhite == color) {
        			Material += my_board[i][k].material_value;  
			}
		}
	}
	return Material; 
}

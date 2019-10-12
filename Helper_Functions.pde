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
				if (curr_board[i][k].get_material_value() == 1) {
					copy[i][k] = new Pawn(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].get_color());
				}
				else if (curr_board[i][k].get_letter() == "n" || curr_board[i][k].get_letter() == "N") {
					copy[i][k] = new Knight(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].get_color());
				}
				else if (curr_board[i][k].get_letter() == "b" || curr_board[i][k].get_letter() == "B") {
					copy[i][k] = new Bishop(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].get_color());
				}
				else if (curr_board[i][k].get_material_value() == 5) {
					copy[i][k] = new Rook(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].get_color());
				}
				else if (curr_board[i][k].get_material_value() == 9) {
					copy[i][k] = new Queen(curr_board[i][k].x_coord, curr_board[i][k].y_coord, curr_board[i][k].get_color());
				}
				else if (curr_board[i][k].get_material_value() == 50) {
					if (curr_board[i][k].get_letter() == "k") {
						copy_white_king = new King(curr_board[i][k].x_coord, curr_board[i][k].y_coord, true);
						copy[i][k] = copy_white_king; 
					}
					if (curr_board[i][k].get_letter() == "K") {
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

//Assign a ProtectedSquare for white 
void new_white_protected (int x, int y, Piece my_piece, ProtectedSquare my_squares[][]) {
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    if (my_squares[y][x] == null) {
        my_squares[y][x] = new ProtectedSquare(x, y, my_piece); 
    }
	else {
		my_squares[y][x].add_defender(my_piece);
		my_squares[y][x].insertion_sort(); 
	}
  }
}

//Assign a ProtectedSquare for black
void new_black_protected (int x, int y, Piece my_piece, ProtectedSquare my_squares[][]) {
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    if (my_squares[y][x] == null) {
        my_squares[y][x] = new ProtectedSquare(x, y, my_piece); 
    }
	else {
		my_squares[y][x].add_defender(my_piece);
		my_squares[y][x].insertion_sort(); 
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

//Check Stalemate 
boolean check_stalemate(King my_king, Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
  if (my_king.num_legal_moves(my_board, for_white, for_black) == 0 && !my_king.in_check(for_white, for_black) && 
    !my_king.checkmate(my_board, for_white, for_black) && my_king.get_color() == white_to_move) {
        for (int i = 0; i < 8; ++i) {
          for (int k = 0; k < 8; ++k) {
            if (my_board[i][k] != null && my_board[i][k].get_color() == my_king.get_color()) {
              for (int a = -2; a <= 2; ++a) {
                for (int b = -2; b <= 2; ++b) {
                  if (my_board[i][k].is_legal(my_board, for_white, for_black, my_board[i][k].SquareX + a, my_board[i][k].SquareY + b)) {
                    return false; 
                  }
                }
              }
            }
          }
        }
        return true;
      }
  return false; 
}

boolean piece_on_board(Piece my_board[][]) {
  for (int i = 0; i < 8; ++i) {
    for (int k = 0; k < 8; ++k) {
      if (my_board[i][k] != null && my_board[i][k].get_material_value() == 3) {
        return true; 
      }
    }
  }
  return false; 
}

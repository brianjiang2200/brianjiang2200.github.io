//Check Stalemate 
boolean check_stalemate(King my_king, Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
  if (my_king.num_legal_moves(my_board, for_white, for_black) == 0 && !my_king.in_check(for_white, for_black) && 
    !my_king.checkmate(my_board, for_white, for_black) && my_king.iswhite == white_to_move) {
        for (int i = 0; i < 8; ++i) {
          for (int k = 0; k < 8; ++k) {
            if (my_board[i][k] != null && my_board[i][k].iswhite == my_king.iswhite) {
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

//Assign a ProtectedSquare onto a ProtectedSquare array
void NewProtected (int x, int y, Piece my_piece, ProtectedSquare my_squares[][]) {
  if (x >= 0 && x <= 7 && y >= 0 && y <= 7) {
    if (my_squares[y][x] == null) {
        my_squares[y][x] = new ProtectedSquare(x, y, my_piece); 
    }
  else {
    my_squares[y][x].add_defender(my_piece);
    //This line no longer needed without engine implementation
    //my_squares[y][x].insertion_sort(); 
  }
  }
}

void refresh_protected(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
  for (int i = 0; i < 8; ++i) {
    for (int k = 0; k < 8; ++k) {
      for_white[i][k] = null; 
      for_black[i][k] = null; 
    }
  }
  for (int i = 0; i < 8; ++i) {
    for (int k = 0; k < 8; ++k) {
      if (my_board[i][k] != null) {
        my_board[i][k].assign_protected_squares(my_board, for_white, for_black); 
      }
    }
  }
}

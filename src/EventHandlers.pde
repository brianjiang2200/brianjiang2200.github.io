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

//Promotion Actions
void promotion_actions() {
    underpromotion_on = false; 
    game_active = true; 
    refresh_protected(piece_board, white_protected_squares, black_protected_squares);
    eval = get_eval(piece_board, white_protected_squares, black_protected_squares);
    if (white_king.checkmate(piece_board, white_protected_squares, black_protected_squares)) {
      game_active = false; 
      game_over = true; 
      color_won = 1; 
    }
    else if (black_king.checkmate(piece_board, white_protected_squares, black_protected_squares)) {
         game_active = false;
         game_over = true;
         color_won = -1; 
    }
    else if (white_king.in_check(white_protected_squares, black_protected_squares) || black_king.in_check(white_protected_squares, black_protected_squares)) {
      main_move_list.tail.check = true; 
    }
    else if (check_stalemate(white_king, piece_board, white_protected_squares, black_protected_squares) || check_stalemate(black_king, piece_board, white_protected_squares, black_protected_squares)) {
      game_active = false;
      game_drawn = true;
      game_over = true; 
    }
    else if (CountMaterial(piece_board, true) == 53 && piece_on_board(piece_board) && CountMaterial(piece_board, false) == 50) {
        game_active = false; 
        game_over = true; 
        game_drawn = true; 
      }
      
    else if (CountMaterial(piece_board, false) == 53 && piece_on_board(piece_board) && CountMaterial(piece_board, true) == 50) {
       game_active = false; 
       game_over = true; 
       game_drawn = true; 
      }
  main_move_list.tail.promotion_piece = piece_board[my_piece.SquareY][my_piece.SquareX].letter.toUpperCase();
  main_move_list.tail.full_move = main_move_list.tail.generate_move(); 
  main_move_list.tail.stored_position = duplicate_board(piece_board);  
}

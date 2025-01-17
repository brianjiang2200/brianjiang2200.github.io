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
    boolean checkNow; 
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
      checkNow = true;  
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
  //DEAL WITH MAIN MOVE LIST 
  main_move_list.tail.promotion_piece = piece_board[my_piece.SquareY][my_piece.SquareX].letter.toUpperCase();
  main_move_list.tail.full_move = main_move_list.tail.generate_move(checkNow); 
  main_move_list.tail.stored_position = duplicate_board(piece_board);
  main_move_list.tail.last_moved = main_move_list.tail.stored_position[my_piece.SquareY][my_piece.SquareX]; 
}

  //removes a Variation
void removeVariation() {
	if (main_move_list.head != null && main_move_list.head != main_move_list.tail) {
		main_move_list.deleteMoveRecord(current_record); 
		current_record = main_move_list.tail;
    notation_top = main_move_list.tail;
		piece_board = duplicate_board(current_record.stored_position); 
		my_piece = piece_board[current_record.last_moved.SquareY][current_record.last_moved.SquareX]; 
		last_moved = my_piece; 
		displayed = piece_board; 
		white_to_move = !current_record.last_moved.iswhite; 
		move_number = (current_record.last_moved.iswhite) ? current_record.move_num : current_record.move_num + 1;
		white_king = piece_board[current_record.wkingy][current_record.wkingx];
		black_king = piece_board[current_record.bkingy][current_record.bkingx];
		refresh_protected(piece_board, white_protected_squares, black_protected_squares);  
		game_active = true;
		game_drawn = false;
		color_won = 0; 
	}
}

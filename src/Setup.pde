//Author: Brian Jiang
//Title: Blindfold Tactics Trainer
//Version 1.67
//Last Update: 2019-10-17

/* @pjs preload="src/Images/Board.png,src/Images/white_pawn.png,src/Images/white_knight.png,src/Images/white_bishop.png,
src/Images/white_king.png,src/Images/white_queen.png,src/Images/white_rook.png,src/Images/black_pawn.png,src/Images/black_knight.png,
src/Images/black_bishop.png,src/Images/black_queen.png,src/Images/black_king.png,src/Images/black_rook.png"; */

void setup() {
 size(1400, 900);
  frameRate(60);
  try {
	  boardimg = loadImage("src/Images/Board.png");
	  whitepawnimg = loadImage("src/Images/white_pawn.png"); 
	  whiteknightimg = loadImage("src/Images/white_knight.png"); 
	  whitebishopimg = loadImage("src/Images/white_bishop.png"); 
	  whitekingimg = loadImage("src/Images/white_king.png"); 
	  whitequeenimg = loadImage("src/Images/white_queen.png"); 
	  whiterookimg = loadImage("src/Images/white_rook.png");
	  blackpawnimg = loadImage("src/Images/black_pawn.png"); 
	  blackknightimg = loadImage("src/Images/black_knight.png"); 
	  blackbishopimg = loadImage("src/Images/black_bishop.png"); 
	  blackqueenimg = loadImage("src/Images/black_queen.png"); 
	  blackkingimg = loadImage("src/Images/black_king.png"); 
	  blackrookimg = loadImage("src/Images/black_rook.png");
  }
  catch (Exception e) {
	  println("There was an error loading the images. Is there a folder titled Images and are all images available?");
  }
  load_opening_positions();
  generate_piece_positions(get_position("Starting_Position"));
  displayed = piece_board; 
  refresh_protected(piece_board, white_protected_squares, black_protected_squares);
  eval = get_eval(piece_board, white_protected_squares, black_protected_squares);
  main_move_list = new MoveList(); 
} 

//RESETS THE PROPERTIES OF THE SKETCH AND THE MAIN BOARD
void resetSketch() {
	move_number = 1; 
	eval = 0; 
	white_to_move = true; 
	piece_selected = false; 
	game_active = true; 
	game_over = false; 
	color_won = 0; 
	game_drawn = false; 
	underpromotion_on = false; 
	my_piece = null; 
	last_moved = null; 
	white_king = null; 
	black_king = null; 
	copy_white_king = null; 
	copy_black_king = null;
	emptyBoard(piece_board); 
	refresh_protected(piece_board, white_protected_squares, black_protected_squares);
	current_record = null; 
	main_move_list.head = null; 
  main_move_list.tail = null; 
  generate_piece_positions(get_position("Starting_Position")); 
}

void mouseClicked() {
	if (!game_active && underpromotion_on) {
    if (mouseX >= 940 && mouseX <= 1010 && mouseY >= 200 && mouseY <= 270) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Knight(my_piece.x_coord, my_piece.y_coord, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= 1020 && mouseX <= 1090 && mouseY >= 200 && mouseY <= 270) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Bishop(my_piece.x_coord, my_piece.y_coord, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= 1100 && mouseX <= 1170 && mouseY >= 200 && mouseY <= 270) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Rook(my_piece.x_coord, my_piece.y_coord, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= 1180 && mouseX <= 1250 && mouseY >= 200 && mouseY <= 270) {
		  piece_board[my_piece.SquareY][my_piece.SquareX] = new Queen(my_piece.x_coord, my_piece.y_coord, my_piece.iswhite);
      promotion_actions(); 
    }
	}
  if (!underpromotion_on) {
    if (mouseX >= 900 && mouseY >= 600 && mouseY <= 800) {
      if (mouseX <= 1100) {
        if (current_record != main_move_list.head) {
          current_record = current_record.prev;
          displayed = current_record.stored_position;
          game_active = false; 
        }
      }
      else if (mouseX <= 1300) {
        if (current_record != main_move_list.tail) {
          current_record = current_record.next;
          displayed = current_record.stored_position;
          if (current_record != main_move_list.tail) {
            game_active = false; 
          }
          else {
            displayed = piece_board; 
            if (!game_over) {
              game_active = true;
            }
          }
        }
      }
    }
  }
}

void keyPressed() {
  if (!underpromotion_on) {
    if (keyCode == LEFT) {
      if (current_record != main_move_list.head) {
          current_record = current_record.prev;
          //NO NEED TO DUPLICATE BOARD AS NO MODIFICATIONS ARE BEING MADE TO THE STORED POSITION
          displayed = current_record.stored_position;
          game_active = false; 
        }
    }
    if (keyCode == RIGHT) {
      if (current_record != main_move_list.tail) {
          current_record = current_record.next;
          if (current_record != main_move_list.tail) {
            //NO NEED TO DUPLICATE BOARD AS NO MODIFICATIONS ARE BEING MADE TO THE STORED POSITION
            displayed = current_record.stored_position;
            game_active = false; 
          }
          else {
            displayed = piece_board; 
            if (!game_over) {
              game_active = true;
            }
          }
        }
    }
    if (keyCode == ALT) {
      removeVariation(); 
    }
  }
}

void mouseDragged() { 
	//determine location in which mouse was clicked and compare it to the board value. 
		//highlight the correct square
	     if (game_active) {
          int tmpy, tmpx;
          if (!piece_selected && mouseX <= 800 && mouseX >= 0 && mouseY <= 800 && mouseY >= 0) {
            tmpy = floor(mouseY/100); 
            tmpx = floor(mouseX/100);
            if (piece_board[tmpy][tmpx] != null && piece_board[tmpy][tmpx].iswhite == white_to_move) {
              my_piece = piece_board[tmpy][tmpx];
              piece_selected = true; 
            }
          }
          else if (piece_selected) {
            my_piece.x_coord = mouseX - 50; 
            my_piece.y_coord = mouseY - 50; 
          }
        }
}

void mouseReleased() {
  if (piece_selected) {
	int newX, newY; 
  //for purposes of capturing in notation
  int material_count;
  boolean piece_captured = false;
  boolean is_check = false;
    if (mouseX <= 0) {
      newX = 0; 
    }
    else if (mouseX >= 800) {
      newX = 7;
    }
    else {
      newX = floor(mouseX/100);
    }
    if (mouseY <= 0) {
      newY = 0; 
    }
    else if (mouseY >= 800) {
      newY = 7; 
    }
    else {
      newY = floor(mouseY/100);
    }
    if (my_piece.is_legal(piece_board, white_protected_squares, black_protected_squares, newX, newY)) {
      
      //for captures in notation
      material_count = (white_to_move) ? CountMaterial(piece_board, false) : CountMaterial(piece_board, true); 
      
      my_piece.x_coord = newX * 100; 
      my_piece.y_coord = newY * 100; 
      piece_board[my_piece.SquareY][my_piece.SquareX] = null;
	  
      //special case of removing a piece captured by en passant
      if (my_piece.material_value == 1 && last_moved != null && last_moved.en_passant) {
         if (newX == last_moved.SquareX && my_piece.SquareY == last_moved.SquareY && newY != last_moved.SquareY) {
           piece_board[last_moved.SquareY][last_moved.SquareX] = null;
         }
      }
      
      piece_board[newY][newX] = my_piece;
      int tmp_x = my_piece.SquareX; 
      int tmp_y = my_piece.SquareY; 
      my_piece.SquareX = newX; 
      my_piece.SquareY = newY;
      refresh_protected(piece_board, white_protected_squares, black_protected_squares);
      
      if (white_to_move && material_count - CountMaterial(piece_board, false) != 0) {
        piece_captured = true; 
      }
      else if (!white_to_move && material_count - CountMaterial(piece_board, true) != 0) {
        piece_captured = true; 
      }
	  
      if (white_king.in_check(white_protected_squares, black_protected_squares)) {
        is_check = true;
        if (white_king.checkmate(piece_board, white_protected_squares, black_protected_squares)) {
          game_active = false;
          game_over = true;
          color_won = 1; 
        }
      }
	  
      else if (black_king.in_check(white_protected_squares, black_protected_squares)) {
        is_check = true; 
        if (black_king.checkmate(piece_board, white_protected_squares, black_protected_squares)) {
          game_active = false;
          game_over = true;
          color_won = -1; 
        }
      }
      
      MoveRecord new_move = new MoveRecord(my_piece, white_king, black_king, piece_board, tmp_x, tmp_y, move_number, piece_captured, is_check);
      main_move_list.add_move(new_move);
      current_record = main_move_list.tail;
      
      if (!white_to_move) {
        move_number++;
      }
      //to_move changes here
      white_to_move = !white_to_move;
      
       //last moved piece
      if (last_moved != null) {
        if (last_moved.en_passant) {
          last_moved.en_passant = false;
        }
      }
        last_moved = my_piece;
      
      //promotion
      if (my_piece.letter == "p" && my_piece.SquareY == 0) {
		    game_active = false; 
		    underpromotion_on = true;  
      }
      else if (my_piece.letter == "P" && my_piece.SquareY == 7) {
        game_active = false; 
		    underpromotion_on = true; 
      }
      if (!my_piece.has_moved) {
        my_piece.has_moved = true; 
        //activating en passant
        if (my_piece.material_value == 1) {
          if (newX > 0 && piece_board[newY][newX - 1] != null && piece_board[newY][newX - 1].material_value== 1 &&
          piece_board[newY][newX - 1].iswhite != my_piece.iswhite) {
            my_piece.en_passant = true;
          }
          else if (newX < 7 && piece_board[newY][newX + 1] != null && piece_board[newY][newX + 1].material_value == 1 &&
          piece_board[newY][newX + 1].iswhite != my_piece.iswhite) {
            my_piece.en_passant = true; 
          }
        }
      }
      
      refresh_protected(piece_board, white_protected_squares, black_protected_squares);
	    //eval = get_eval(piece_board, white_protected_squares, black_protected_squares);
      current_record = main_move_list.tail; 
      
      //CASES WHEN GAME ENDS IN DRAW AUTOMATICALLY
      int tmpWhiteMaterial = CountMaterial(piece_board, true); 
      int tmpBlackMaterial = CountMaterial(piece_board, false); 
      //CASE WHEN ONLY TWO KINGS LEFT ON BOARD
      if (tmpWhiteMaterial == 50 && tmpBlackMaterial == 50) {
        game_active = false;
        game_over = true;
        game_drawn = true; 
      }
      //CASE WHEN K AND PIECE VS K
      else if (tmpWhiteMaterial == 53 && piece_on_board(piece_board) && tmpBlackMaterial == 50) {
        game_active = false; 
        game_over = true; 
        game_drawn = true; 
      }
      //CASE WHEN K VS K AND PIECE
      else if (tmpBlackMaterial == 53 && piece_on_board(piece_board) && tmpWhiteMaterial == 50) {
        game_active = false; 
        game_over = true; 
        game_drawn = true; 
      }
      //CHECK IF WHITE IS STALEMATED
      else if (check_stalemate(white_king, piece_board, white_protected_squares, black_protected_squares)) {
        game_active = false;
        game_over = true; 
        game_drawn = true; 
      }
      //CHECK IF BLACK IS STALEMATED
      else if (check_stalemate(black_king, piece_board, white_protected_squares, black_protected_squares)) {
        game_active = false;
        game_over = true; 
        game_drawn = true; 
      }
    }
    //ELSE FROM .is_legal() condition
    else {
      my_piece.x_coord = my_piece.SquareX * 100; 
      my_piece.y_coord = my_piece.SquareY * 100; 
    }
  }
  piece_selected = false; 
}

//GET ALL OPENING POSITIONS 
void load_opening_positions() {
  try {
	  read_positions_repo = loadStrings("src/Positions_Repository.txt");
  } 
  catch (Exception e) {
	  println("There was an error loading the Positions_Repository File.");
  }
}

String[] get_position(String position_name) {
	String[] position_string = new String[8]; 
	for (int i = 0; i < read_positions_repo.length; ++i) {
		if (read_positions_repo[i].equals(position_name)) {
			try {
				position_string[0] = read_positions_repo[i + 1]; 
				position_string[1] = read_positions_repo[i + 2]; 
				position_string[2] = read_positions_repo[i + 3]; 
				position_string[3] = read_positions_repo[i + 4]; 
				position_string[4] = read_positions_repo[i + 5]; 
				position_string[5] = read_positions_repo[i + 6]; 
				position_string[6] = read_positions_repo[i + 7]; 
				position_string[7] = read_positions_repo[i + 8];
			}
			catch (Exception e) {
				println("There was an error loading the specified position. Check that that no rows or columns have been deleted from the Positions_Repository file.");
			}
			break; 
		}
	}
	return position_string; 
}

void generate_piece_positions (String my_strings[]) {
	emptyBoard(piece_board);  
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			String myChar = str(my_strings[i].charAt(k));
			if (!myChar.equals("/")) {
			//SHOW WHITE PIECES
				if (myChar.equals("p")) {
					piece_board[i][k] = new Pawn(k * 100, i * 100, true); 
				}
				else if (myChar.equals("b")) {
					piece_board[i][k] = new Bishop(k * 100, i * 100, true);
				}
				else if (myChar.equals("n")) {
          				piece_board[i][k] = new Knight(k * 100, i * 100, true);
				}
				else if (myChar.equals("r")) {
          				piece_board[i][k] = new Rook(k * 100, i * 100, true);
				}
				else if (myChar.equals("q")) {
          				piece_board[i][k] = new Queen(k * 100, i * 100, true); 
				}
				else if (myChar.equals("k")) {
					white_king = new King(k * 100, i * 100, true);
          				piece_board[i][k] = white_king; 
				}
			//SHOW BLACK PIECES 
				else if (myChar.equals("P")) {
          				piece_board[i][k] = new Pawn(k * 100, i * 100, false); 
				}
				else if (myChar.equals("B")) {
          				piece_board[i][k] = new Bishop(k * 100, i * 100, false); 
				}
				else if (myChar.equals("N")) {
          				piece_board[i][k] = new Knight(k * 100, i * 100, false); 
				}
				else if (myChar.equals("R")) { 
          				piece_board[i][k] = new Rook(k * 100, i * 100, false);
				}
				else if (myChar.equals("Q")) {
          				piece_board[i][k] = new Queen(k * 100, i * 100, false); 
				}
				else if (myChar.equals("K")) {
					black_king = new King(k * 100, i * 100, false);
          				piece_board[i][k] = black_king; 
				}
			}
		}
	}
}

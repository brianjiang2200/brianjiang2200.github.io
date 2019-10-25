//Author: Brian Jiang
//Title: Blindfold Tactics Trainer
//Version 1.240
//Last Update: 2019-10-23

/* @pjs preload="src/Images/Board.png,src/Images/white_pawn.png,src/Images/white_knight.png,src/Images/white_bishop.png,
src/Images/white_king.png,src/Images/white_queen.png,src/Images/white_rook.png,src/Images/black_pawn.png,src/Images/black_knight.png,
src/Images/black_bishop.png,src/Images/black_queen.png,src/Images/black_king.png,src/Images/black_rook.png"; */

void setup() {
  //Set Canvas to size specified by HTML document
  try {
    size(getSketchWidth("sketch"), getSketchHeight("sketch")); 
  }
  catch (Exception e) {
   println(e); 
   println("Initiating default canvas size"); 
   size(1400, 900);
  }
  
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
  //Initialize some variables after size() has been formally declared
  piecedim = Xnorm(100);
  white_move_list_x = Xnorm(920); 
  black_move_list_x = Xnorm(1120); 
  move_list_y = Ynorm(570);
  Xmap800 = Xnorm(800); 
  Ymap800 = Ynorm(800);
  MCupperY = Ynorm(200);
  MClowerY = Ynorm(270);
  
  //Set up Main Board
  main_move_list = new MoveList();
  load_opening_positions();
  generate_piece_positions(get_position("Starting_Position"));
  displayed = piece_board; 
  refresh_protected(piece_board, white_protected_squares, black_protected_squares);
  eval = get_eval(piece_board, white_protected_squares, black_protected_squares);
  
  //Initialize DOM Objects
  OpeningPositionsList = returnOpeningNames(); 
  generateOpeningsListonWindow("hiddenOpeningsList"); 
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
}

void mouseClicked() {
	if (!game_active && underpromotion_on) {
    float upperY = Ynorm(200);
    float lowerY = Ynorm(270);
    if (mouseX >= Xnorm(940) && mouseX <= Xnorm(1010) && mouseY >= MCupperY && mouseY <= MClowerY) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Knight(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= Xnorm(1020) && mouseX <= Xnorm(1090) && mouseY >= MCupperY && mouseY <= MClowerY) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Bishop(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= Xnorm(1100) && mouseX <= Xnorm(1170) && mouseY >= MCupperY && mouseY <= MClowerY) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Rook(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= Xnorm(1180) && mouseX <= Xnorm(1250) && mouseY >= MCupperY && mouseY <= MClowerY) {
		  piece_board[my_piece.SquareY][my_piece.SquareX] = new Queen(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
	}
  else if (!underpromotion_on) {
    if (mouseX >= Xnorm(900) && mouseY >= Ynorm(600) && mouseY <= Ymap800) {
      if (mouseX <= Xnorm(1100)) {
        if (current_record != main_move_list.head) {
          current_record = current_record.prev;
          displayed = current_record.stored_position;
          game_active = false; 
        }
      }
      else if (mouseX <= Xnorm(1300)) {
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
          if (!piece_selected && mouseX <= Xmap800 && mouseX >= 0 && mouseY <= Ymap800 && mouseY >= 0) {
            tmpy = floor(invYNorm(mouseY)/100); 
            tmpx = floor(invXNorm(mouseX)/100);
            if (piece_board[tmpy][tmpx] != null && piece_board[tmpy][tmpx].iswhite == white_to_move) {
              my_piece = piece_board[tmpy][tmpx];
              piece_selected = true; 
            }
          }
          else if (piece_selected) {
            my_piece.x_coord = mouseX - piecedim/2; 
            my_piece.y_coord = mouseY - piecedim/2; 
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
    else if (mouseX >= Xmap800) {
      newX = 7;
    }
    else {
      newX = floor(invXNorm(mouseX)/100);
    }
    if (mouseY <= 0) {
      newY = 0; 
    }
    else if (mouseY >= Ymap800) {
      newY = 7; 
    }
    else {
      newY = floor(invYNorm(mouseY)/100);
    }
    if (my_piece.is_legal(piece_board, white_protected_squares, black_protected_squares, newX, newY)) {
      
      //for captures in notation
      material_count = (white_to_move) ? CountMaterial(piece_board, false) : CountMaterial(piece_board, true); 
      
      my_piece.x_coord = newX * piecedim; 
      my_piece.y_coord = newY * piecedim; 
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
      my_piece.x_coord = my_piece.SquareX * piecedim; 
      my_piece.y_coord = my_piece.SquareY * piecedim; 
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

String[] returnOpeningNames() {
	if (read_positions_repo.length % 9 != 0) {
		println("PositionsRepository Text Invalid Format");
		String[] nullString = new String[1]; 
		nullString[0] = ""; 
		return nullString; 
	}
	String[] OpeningOptions = new String[read_positions_repo.length/9];
	int optionsCount = 0; 
	for (int i = 0; i < read_positions_repo.length; i = i + 9) {
		if (!read_positions_repo[i].equals("")) {
			OpeningOptions[optionsCount] = read_positions_repo[i];
			optionsCount++; 
		}
		else {
			println("PositionsRepository Text Invalid Format"); 
			break; 
		}
	}
	return OpeningOptions; 
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
	resetSketch();  
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			String myChar = str(my_strings[i].charAt(k));
			if (!myChar.equals("/")) {
			//SHOW WHITE PIECES
				if (myChar.equals("p")) {
					piece_board[i][k] = new Pawn(k, i, true); 
				}
				else if (myChar.equals("b")) {
					piece_board[i][k] = new Bishop(k, i, true);
				}
				else if (myChar.equals("n")) {
          				piece_board[i][k] = new Knight(k, i, true);
				}
				else if (myChar.equals("r")) {
          				piece_board[i][k] = new Rook(k, i, true);
				}
				else if (myChar.equals("q")) {
          				piece_board[i][k] = new Queen(k, i, true); 
				}
				else if (myChar.equals("k")) {
					        white_king = new King(k, i, true);
          				piece_board[i][k] = white_king; 
				}
			//SHOW BLACK PIECES 
				else if (myChar.equals("P")) {
          				piece_board[i][k] = new Pawn(k, i, false); 
				}
				else if (myChar.equals("B")) {
          				piece_board[i][k] = new Bishop(k, i, false); 
				}
				else if (myChar.equals("N")) {
          				piece_board[i][k] = new Knight(k, i, false); 
				}
				else if (myChar.equals("R")) { 
          				piece_board[i][k] = new Rook(k, i, false);
				}
				else if (myChar.equals("Q")) {
          				piece_board[i][k] = new Queen(k, i, false); 
				}
				else if (myChar.equals("K")) {
					black_king = new King(k, i, false);
          				piece_board[i][k] = black_king; 
				}
			}
		}
	}
}

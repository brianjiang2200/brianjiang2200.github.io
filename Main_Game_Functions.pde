//Author: Brian Jiang
//Title: Blindfold Tactics Trainer
//Version 1.136
//Last Update: 2019-05-03

//Images
PImage boardimg;
PImage whitepawnimg, whiteknightimg, whitebishopimg, whitekingimg, whitequeenimg, whiterookimg;
PImage HIwhitepawnimg, HIwhiteknightimg, HIwhitebishopimg, HIwhitekingimg, HIwhitequeenimg, HIwhiterookimg; 
PImage blackpawnimg, blackknightimg, blackbishopimg, blackkingimg, blackqueenimg, blackrookimg;
PImage HIblackpawnimg, HIblackknightimg, HIblackbishopimg, HIblackkingimg, HIblackqueenimg, HIblackrookimg; 

void setup() {
  size(1400, 900);
  frameRate(60);
  try {
	  boardimg = loadImage("/Images/Board.png");
	  whitepawnimg = loadImage("Images/white_pawn.png"); 
	  whiteknightimg = loadImage("Images/white_knight.png"); 
	  whitebishopimg = loadImage("Images/white_bishop.png"); 
	  whitekingimg = loadImage("Images/white_king.png"); 
	  whitequeenimg = loadImage("Images/white_queen.png"); 
	  whiterookimg = loadImage("Images/white_rook.png");
    HIwhitepawnimg = loadImage("Images/highlighted_white_pawn.PNG");
    HIwhiteknightimg = loadImage("Images/highlighted_white_knight.png"); 
    HIwhitebishopimg = loadImage("Images/highlighted_white_bishop.PNG"); 
    HIwhitekingimg = loadImage("Images/highlighted_white_king.PNG"); 
    HIwhitequeenimg = loadImage("Images/highlighted_white_queen.PNG");
    HIwhiterookimg = loadImage("Images/highlighted_white_rook.PNG");
	  blackpawnimg = loadImage("Images/black_pawn.png"); 
	  blackknightimg = loadImage("Images/black_knight.png"); 
	  blackbishopimg = loadImage("Images/black_bishop.png"); 
	  blackqueenimg = loadImage("Images/black_queen.png"); 
	  blackkingimg = loadImage("Images/black_king.png"); 
	  blackrookimg = loadImage("Images/black_rook.png");
    HIblackpawnimg = loadImage("Images/highlighted_black_pawn.PNG");
    HIblackknightimg = loadImage("Images/highlighted_black_knight.PNG"); 
    HIblackbishopimg = loadImage("Images/highlighted_black_bishop.PNG"); 
    HIblackkingimg = loadImage("Images/highlighted_black_king.PNG"); 
    HIblackqueenimg = loadImage("Images/highlighted_black_queen.PNG");
    HIblackrookimg = loadImage("Images/highlighted_black_rook.PNG");
  }
  catch (Exception e) {
	  println("There was an error loading the images. Is there a folder titled Images and are all images available?");
  }
  load_opening_positions(); 
  generate_piece_positions(get_position("Starting_Position"));
  displayed = piece_board; 
  refresh_protected(piece_board, white_protected_squares, black_protected_squares);
  eval = get_eval(piece_board, white_protected_squares, black_protected_squares); 
} 

//GAME PROPERTIES
int piecedim = 100;
int move_number = 1; 
float eval = 0; 
boolean white_to_move = true; 
boolean piece_selected = false;
boolean game_active = true;
//controls whether pieces can be moved. 
boolean game_over = false;
//true if game is actually over.
int color_won = 0; 
//used to determine which side won. Checkmate() does not have to be called each frame. -1 for black win and 1 for white win, 0 otherwise.  
boolean game_drawn = false; 
boolean underpromotion_on = false;
//IMPORTANT PIECES
Piece my_piece;
King white_king;
King copy_white_king; 
King black_king;
King copy_black_king; 
Piece last_moved; 

//STRING ARRAY CONTAINING ALL OPENING POSITIONS 
String[] read_positions_repo; 

//MAIN BOARD SQUARES PROTECTED BY WHITE
ProtectedSquare [] [] white_protected_squares = new ProtectedSquare[8][8]; 

//MAIN BOARD SQUARES PROTECTED BY BLACK
ProtectedSquare [] [] black_protected_squares = new ProtectedSquare[8][8]; 

//MAIN BOARD
Piece [] [] piece_board = new Piece[8][8];

//DISPLAYED BOARD
Piece [] [] displayed = new Piece[8][8]; 

//MAIN MOVE LIST 
MoveList main_move_list = new MoveList();
MoveRecord current_record; 

//DISPLAY PROPERTIES 
int white_move_list_x = 920;
int black_move_list_x = 1120; 
int move_list_y = 570;

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
          displayed = current_record.stored_position;
          game_active = false; 
        }
    }
    if (keyCode == RIGHT) {
      if (current_record != main_move_list.tail) {
          current_record = current_record.next;
          if (current_record != main_move_list.tail) {
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
    else if (count_white_material(piece_board) == 53 && piece_on_board(piece_board) && count_black_material(piece_board) == 50) {
        game_active = false; 
        game_over = true; 
        game_drawn = true; 
      }
      
    else if (count_black_material(piece_board) == 53 && piece_on_board(piece_board) && count_white_material(piece_board) == 50) {
       game_active = false; 
       game_over = true; 
       game_drawn = true; 
      }
  main_move_list.tail.promotion_piece = piece_board[my_piece.SquareY][my_piece.SquareX].letter.toUpperCase();
  main_move_list.tail.full_move = main_move_list.tail.generate_move(); 
  main_move_list.tail.stored_position = duplicate_board(piece_board);  
}

void mouseDragged() { 
	//determine location in which mouse was clicked and compare it to the board value. 
		//highlight the correct square
	     if (mouseX > 0 && mouseY > 0 && mouseX < 800 && mouseY < 800 && game_active) {
          int tmpy = floor(mouseY/100); 
          int tmpx = floor(mouseX/100); 
          if (!piece_selected && piece_board[tmpy][tmpx] != null && piece_board[tmpy][tmpx].iswhite == white_to_move) {
            my_piece = piece_board[tmpy][tmpx];
            piece_selected = true; 
          }
          else if (piece_selected) {
            my_piece.x_coord = mouseX - 50; 
            my_piece.y_coord = mouseY - 50;
          }
        }
}

void mouseReleased() {
  if (piece_selected) {
	int newX;
	int newY;
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
      material_count = (white_to_move) ? count_black_material(piece_board) : count_white_material(piece_board); 
      
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
      
      if (white_to_move && material_count - count_black_material(piece_board) != 0) {
        piece_captured = true; 
      }
      else if (!white_to_move && material_count - count_white_material(piece_board) != 0) {
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
      
      MoveRecord new_move = new MoveRecord(my_piece, piece_board, tmp_x, tmp_y, move_number, piece_captured, is_check);
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
        last_moved.assign_visual(false); 
      }
        last_moved = my_piece;
        //Highlight current piece
        my_piece.assign_visual(true); 
      
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
	    eval = get_eval(piece_board, white_protected_squares, black_protected_squares);
      
      //CASES WHEN GAME ENDS IN DRAW AUTOMATICALLY
      //case when only two kings left on board
      if (count_white_material(piece_board) == 50 && count_black_material(piece_board) == 50) {
        game_active = false;
        game_over = true;
        game_drawn = true; 
      }
      
      else if (count_white_material(piece_board) == 53 && piece_on_board(piece_board) && count_black_material(piece_board) == 50) {
        game_active = false; 
        game_over = true; 
        game_drawn = true; 
      }
      
      else if (count_black_material(piece_board) == 53 && piece_on_board(piece_board) && count_white_material(piece_board) == 50) {
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
	  read_positions_repo = loadStrings("Positions_Repository.txt");
  } 
  catch (Exception e) {
	  println("There was an error loading the Positions_Repository File.");
  }
}

String[] get_position(String position_name) {
	String[] position_string = new String[8]; 
	for (int i = 0; i < read_positions_repo.length; ++i) {
		if (read_positions_repo[i] == position_name) {
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
  image(boardimg, 0, 0, 800, 800); 
	//This function should only be called once a round during board setup. 
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (!str(my_strings[i].charAt(k)).equals("/")) {
			//Show each piece
				if (str(my_strings[i].charAt(k)).equals("p")) {
					Pawn new_pawn = new Pawn(k * 100, i * 100, true);   
					piece_board[i][k] = new_pawn; 
          new_pawn.display(); 
				}
				else if (str(my_strings[i].charAt(k)).equals("b")) {
					Bishop new_bishop = new Bishop(k * 100, i * 100, true);
          piece_board[i][k] = new_bishop; 
					new_bishop.display(); 
				}
				else if (str(my_strings[i].charAt(k)).equals("n")) {
					Knight new_knight = new Knight(k * 100, i * 100, true);
          piece_board[i][k] = new_knight; 
					new_knight.display();  
				}
				else if (str(my_strings[i].charAt(k)).equals("r")) {
					Rook new_rook = new Rook(k * 100, i * 100, true);
          piece_board[i][k] = new_rook; 
					new_rook.display();  
				}
				else if (str(my_strings[i].charAt(k)).equals("q")) {
					Queen new_queen = new Queen(k * 100, i * 100, true);
          piece_board[i][k] = new_queen;
					new_queen.display();  
				}
				else if (str(my_strings[i].charAt(k)).equals("k")) {
					white_king = new King(k * 100, i * 100, true);
          piece_board[i][k] = white_king; 
					white_king.display(); 
				}
			//Black 
				else if (str(my_strings[i].charAt(k)).equals("P")) {
					Pawn new_pawn = new Pawn(k * 100, i * 100, false);
          piece_board[i][k] = new_pawn; 
					new_pawn.display(); 
				}
				else if (str(my_strings[i].charAt(k)).equals("B")) {
					Bishop new_bishop = new Bishop(k * 100, i * 100, false);
          piece_board[i][k] = new_bishop; 
					new_bishop.display(); 
				}
				else if (str(my_strings[i].charAt(k)).equals("N")) {
					Knight new_knight = new Knight(k * 100, i * 100, false);
          piece_board[i][k] = new_knight; 
					new_knight.display();   
				}
				else if (str(my_strings[i].charAt(k)).equals("R")) {
					Rook new_rook = new Rook(k * 100, i * 100, false); 
          piece_board[i][k] = new_rook; 
					new_rook.display();  
				}
				else if (str(my_strings[i].charAt(k)).equals("Q")) {
					Queen new_queen = new Queen(k * 100, i * 100, false);
          piece_board[i][k] = new_queen; 
					new_queen.display();  
				}
				else if (str(my_strings[i].charAt(k)).equals("K")) {
					black_king = new King(k * 100, i * 100, false);
          piece_board[i][k] = black_king; 
					black_king.display();  
				}
			}
		}
	}
}

int count_white_material(Piece my_board[][]) {
	int white_material = 0; 
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (my_board[i][k] != null && my_board[i][k].iswhite == true) {
        white_material += my_board[i][k].material_value;  
			}
		}
	}
	return white_material; 
}

int count_black_material(Piece my_board[][]) {
	int black_material = 0; 
	for (int i = 0; i < 8; ++i) {
		for (int k = 0; k < 8; ++k) {
			if (my_board[i][k] != null && my_board[i][k].iswhite == false) {
				 black_material += my_board[i][k].material_value; 
			}
		}
	}
	return black_material; 
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

void draw_menu() {
  stroke(255);
  strokeWeight(1);
  fill(25, 25, 25);
  rect(800,0,600,800);
  fill(43, 43, 43);
  rect(1230,20,150,50);
  rect(900,100,400,500);
  //Previous Move Button
  rect(900,600,200,70);
  //Next Move Button
  rect(1100,600,200,70);
  rect(800,720,300,80);
  rect(1100,720,300,80);
  textSize(50);
  fill(255);
  //Button Text
  text("<", 985, 650); 
  text(">", 1185, 650);
  textSize(30);
  text("QUIT",1265,55);
  textSize(30); 
  fill(0); 
  rect(0,800,1400,100);
  fill(255); 
  text("Running Evaluation: " + eval, 30, 860); 
  
  try { 
     if (main_move_list.tail != null && !underpromotion_on) {
         if (main_move_list.tail.move_num < 9) {
           for (MoveRecord my_record = main_move_list.head; (my_record != null && my_record.move_num - main_move_list.tail.move_num < 8); my_record = my_record.next) {
             if (my_record.to_move) {
               my_record.print_move(white_move_list_x, move_list_y - 420 + (my_record.move_num - 1) * 60); 
             }
             else {
               my_record.print_move(black_move_list_x, move_list_y - 420 + (my_record.move_num - 1) * 60); 
             }
           }
         }
         else {
           for (MoveRecord my_record = main_move_list.tail; (my_record != null && main_move_list.tail.move_num - my_record.move_num < 8); my_record = my_record.prev) {
             if (my_record.to_move) {
               my_record.print_move(white_move_list_x, move_list_y + (my_record.move_num - main_move_list.tail.move_num) * 60);
             }
             else {
               my_record.print_move(black_move_list_x, move_list_y + (my_record.move_num - main_move_list.tail.move_num) * 60); 
             }
           }
         }
     }
  }
  catch (Exception e) {
     println("Error on printing Move List"); 
  }
  
  textSize(30); 
  if (game_active) {
    if (white_to_move) {
      text("White to move", 1010, 865);
    }
    else {
      text("Black to move", 1010, 865);
    } 
  }
  if (!game_active) {
    if (color_won > 0) {
      textSize(40); 
      text("0 - 1", 1060, 865);
    }
    else if (color_won < 0) {
      textSize(40); 
      text("1 - 0", 1060, 865);
    }
  else if (underpromotion_on) {
    textSize(30); 
    text("Select Promotion Piece",945,150);
    if (my_piece.iswhite) {
      image(whiteknightimg,940,200,70,70); 
      image(whitebishopimg,1020,200,70,70);
      image(whiterookimg,1100,200,70,70); 
      image(whitequeenimg,1180,200,70,70);
    }
    else {
      image(blackknightimg,940,200,70,70); 
      image(blackbishopimg,1020,200,70,70); 
      image(blackrookimg,1100,200,70,70); 
      image(blackqueenimg,1180,200,70,70); 
    }
  }
    else if (game_drawn) {
      textSize(40); 
      text("1/2 - 1/2", 1035, 865);
    }
    else {
      textSize(27);
      text("Position after", 870, 865); 
      current_record.print_move(1035, 865);   
    }
  }
}

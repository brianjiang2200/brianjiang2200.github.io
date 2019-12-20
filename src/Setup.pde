//Author: Brian Jiang
//Title: Blindfold Tactics Trainer
//Version 1.293
//Last Update: 2019-10-25

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
  white_move_list_x = Xnorm(870); 
  black_move_list_x = Xnorm(1070); 
  move_list_y = Ynorm(520);
  Xmap800 = Xnorm(800); 
  Ymap800 = Ynorm(800);
  //For Promotion Pieces
  MCupperY = Ynorm(150);
  MClowerY = Ynorm(220);
  
  //Set up Main Board
  main_move_list = new MoveList();
  load_opening_positions();
  if (!ParseFEN(get_position("Starting Position"))) {
    println("Cannot Parse FEN"); 
    resetSketch(); 
  }
  
  //Initialize DOM Objects
  OpeningPositionsList = returnOpeningNames(); 
  generateOpeningsListonWindow("hiddenOpeningsList");
  document.getElementById("addAnnotationBtn").addEventListener("click", function() {
    addAnnotation(document.getElementById("annotationinput").value)
  }); 
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
	displayed = piece_board; 
	current_record = null; 
	main_move_list.head = null; 
  main_move_list.tail = null;  
}

void mouseClicked() {
	if (!game_active && underpromotion_on) {
    if (mouseX >= Xnorm(890) && mouseX <= Xnorm(960) && mouseY >= MCupperY && mouseY <= MClowerY) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Knight(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= Xnorm(970) && mouseX <= Xnorm(1040) && mouseY >= MCupperY && mouseY <= MClowerY) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Bishop(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= Xnorm(1050) && mouseX <= Xnorm(1120) && mouseY >= MCupperY && mouseY <= MClowerY) {
      piece_board[my_piece.SquareY][my_piece.SquareX] = new Rook(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
    }
    else if (mouseX >= Xnorm(1130) && mouseX <= Xnorm(1210) && mouseY >= MCupperY && mouseY <= MClowerY) {
		  piece_board[my_piece.SquareY][my_piece.SquareX] = new Queen(my_piece.SquareX, my_piece.SquareY, my_piece.iswhite);
      promotion_actions(); 
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
    else if (keyCode == RIGHT) {
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
    else if (keyCode == UP) {
      if (notation_top.move_num > 8) {
        notation_top = notation_top.prev; 
        notation_top = (notation_top.prev.last_moved.iswhite) ? notation_top : notation_top.prev;
      }
    }
    else if (keyCode == DOWN) {
      if (notation_top != main_move_list.tail) {
        notation_top = notation_top.next; 
        notation_top = (notation_top == main_move_list.tail) ? notation_top : notation_top.next; 
      }
    }
    else if (keyCode == ALT) {
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
      notation_top = main_move_list.tail; 
      
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
	  read_positions_repo = loadStrings("src/OpeningRepository.txt");
  } 
  catch (Exception e) {
	  println("There was an error loading the Opening Repository File.");
  }
}

String[] returnOpeningNames() {
	if (read_positions_repo.length % 2 != 0) {
		println("Opening Repository Text Invalid Format");
		String[] nullString = new String[1]; 
		nullString[0] = ""; 
		return nullString; 
	}
	String[] OpeningOptions = new String[read_positions_repo.length/2];
	int optionsCount = 0; 
	for (int i = 0; i < read_positions_repo.length; i += 2) {
		if (!read_positions_repo[i].equals("")) {
			OpeningOptions[optionsCount] = read_positions_repo[i];
			optionsCount++; 
		}
		else {
			println("Opening Repository Text File Invalid Format"); 
			break; 
		}
	}
	return OpeningOptions; 
}

String get_position(String position_name) {
	for (int i = 0; i < read_positions_repo.length; ++i) {
		if (read_positions_repo[i].equals(position_name)) {
      if (i != read_positions_repo.length - 1) {
        return read_positions_repo[i + 1]; 
      }
      else {
        //return starting position
        return "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"; 
      }
		}
  }
  //return starting position
	return "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"; 
}

/***********************SAMPLE INPUT*****************
rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
After 1.e4
rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1
After 1...c5
rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2
After 2.Nf3
rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2
**********************************************************/

boolean ParseFEN(String FEN) {
  resetSketch();
  String[] list = split(FEN, ' '); 
  if (list.length != 6) {
    println("FEN Too many arguments");
    return false; 
  }
  
  //list[0]
  int row = 7; 
  int column = 0;
  for (int k = 0; k < list[0].length; ++k) {
    switch (list[0].charAt(k)) {
      //Cases ordered by most frequently occurring values
      case 'p': 
        piece_board[row][column] = new Pawn(column, row, true); 
        break; 
      case 'P': 
        piece_board[row][column] = new Pawn(column, row, false);
        break;
      case '1': 
        column++;
        break; 
      case '2': 
        column += 2; 
        break; 
      case '3': 
        column += 3;
        break; 
      case '4': 
        column += 4; 
        break; 
      case '5': 
        column += 5; 
        break; 
      case 'n': 
        piece_board[row][column] = new Knight(column, row, true); 
        break;
      case 'N': 
        piece_board[row][column] = new Knight(column, row, false); 
        break; 
      case 'b': 
        piece_board[row][column] = new Bishop(column, row, true); 
        break; 
      case 'B': 
        piece_board[row][column] = new Bishop(column, row, false); 
        false; 
      case 'r': 
        piece_board[row][column] = new Rook(column, row, true); 
        break; 
      case 'R': 
        piece_board[row][column] = new Rook(column, row, false); 
        break;
      case '6': 
        column += 6; 
        break; 
      case 'q': 
        piece_board[row][column] = new Queen(column, row, true); 
        break; 
      case 'Q': 
        piece_board[row][column] = new Queen(column, row, false); 
        break;
      case '7': 
        column += 7; 
        break; 
      case '8':
        column += 8; 
      case 'k': 
        piece_board[row][column] = new King(column, row, true);
        white_king = piece_board[row][column]; 
        break; 
      case 'K':
        piece_board[row][column] = new King(column, true, false);
        black_king = piece_board[row][column]; 
        break; 
      default:
        //this case will also trap instances of '/' that occur early
        println("Invalid Character in FEN Board Descriptor"); 
        return false;
    }
    //must trap error instances here
    column++;
    if (k != list[0].length - 1) {
      if (column == 8) {
        k++; 
        if (list[0].charAt(k) == '/') {
          column = 0; 
          if (row > 0) {
            row--; 
          }
          else {
            println("Invalid FEN Board Descriptor Format"); 
            return false; 
          }
        }
        else {
          println("Invalid FEN Board Descriptor Format"); 
          return false; 
        }
      }
    }
  }
  
  //list[1]
  if (list[1].length == 1) {
    //set white to move by default even if error case
    white_to_move = (list[1].charAt(0) == 'b') ? false : true; 
  }
  else {
    println("Invalid FEN: Color to Move"); 
    return false; 
  }
  
  //list[2] - castling
  if (match(list[2], "k") == null) {
    if (piece_board[7][7] != null && piece_board[7][7].letter.equals("r")) {
      piece_board[7][7].has_moved = true; 
    }
  }
  if (match(list[2], "K") == null) {
    if (piece_board[0][7] != null && piece_board[7][7].letter.equals("R")) {
      piece_board[0][7].has_moved = true; 
    }
  }
  if (match(list[2], "q") == null) {
    if (piece_board[7][0] != null && piece_board[7][0].letter.equals("r")) {
      piece_board[7][0].has_moved = true; 
    }
  }
  if (match(list[2], "Q") == null) {
    if (piece_board[0][0] != null && piece_board[0][0].letter.equals("R")) {
      piece_board[0][0].has_moved = true; 
    }
  }
  
  //list[3] - en passant
  if (!list[3].equals("-")) {
    if (list[3].length != 2) {
      println("Invalid FEN"); 
      return false; 
    }
    else if (str(list[3].charAt(1)) == "3" && XtoNum.get(list[3].charAt(0)) != null) {
      Piece dummy = piece_board[4][XtoNum.get(str(list[3].charAt(0)))]; 
      if (dummy != null && dummy.letter.equals("p")) {
        dummy.en_passant = true;
        last_moved = dummy; 
      }
    }
    else if (str(list[3].charAt(1)) == "6" && XtoNum.get(str(list[3].charAt(0))) != null) {
      Piece dummy = piece_board[3][XtoNum.get(str(list[3].charAt(0)))]; 
      if (dummy != null && dummy.letter.equals("P")) {
        dummy.en_passant = true; 
        last_moved = dummy; 
      }
    }
  }
  
  //list[4] - half moves since last capture
  //Do nothing
  
  //list[5] - full moves played, incremented after black has moved
  if (list[5].length > 3) {
    println("FEN Move Number Too Large"); 
    return false; 
  }
  move_number = (int) list[5]; 
  
  //reset board if function returns false
  return true; 
}

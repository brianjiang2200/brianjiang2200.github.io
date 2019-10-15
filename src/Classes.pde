class MoveRecord {
  //Position stored at this point
  Piece[][] stored_position;
  //Piece just moved
  Piece last_moved; 
  //Move Number 
  int move_num;
  //Side to Move
  boolean to_move;
  //Notation elements
  boolean check; 
  String notation_piece;
  String previous_x;
  int previous_y; 
  String notation_col; 
  int notation_row;
  String promotion_piece = "";
  String captures = ""; 
  String full_move; 
  MoveRecord next;
  MoveRecord prev; 
  
  MoveRecord (Piece my_piece, Piece new_pos[][], int prev_x, int prev_y, int move_no, boolean capture, boolean is_check) {
    stored_position = duplicate_board(new_pos);
    last_moved = stored_position[my_piece.SquareY][my_piece.SquareX]; 
    HIGHLIGHT_SQUARES(); 
    to_move = my_piece.iswhite;
    move_num = move_no;
    notation_piece = (my_piece.material_value == 1) ? "" : my_piece.letter.toUpperCase();
    switch (prev_x) {
      case 0: 
        this.previous_x = "a";
        break;
      case 1:
        this.previous_x = "b";
        break;
      case 2: 
        this.previous_x = "c";
        break;
      case 3: 
        this.previous_x = "d";
        break;
      case 4: 
        this.previous_x = "e";
        break;
      case 5: 
        this.previous_x = "f";
        break;
      case 6: 
        this.previous_x = "g";
        break;
      case 7: 
        this.previous_x = "h";
        break;
      default: 
        this.previous_x = "?"; 
    }
    switch (my_piece.SquareX) {
      case 0: 
        this.notation_col = "a";
        break;
      case 1:
        this.notation_col = "b";
        break;
      case 2: 
        this.notation_col = "c";
        break;
      case 3: 
        this.notation_col = "d";
        break;
      case 4: 
        this.notation_col = "e";
        break;
      case 5: 
        this.notation_col = "f";
        break;
      case 6: 
        this.notation_col = "g";
        break;
      case 7: 
        this.notation_col = "h";
        break;
      default: 
        this.notation_col = "?"; 
    }
    previous_y = 8 - prev_y; 
    notation_row = 8 - my_piece.SquareY; 
    next = null;
    prev = null;
    captures = (capture) ? " x " : " - ";
    check = is_check;
    full_move = generate_move();
  }
  
  String generate_move() {
    if (notation_piece.equals("K") && previous_x.equals("e") && notation_col.equals("g")) {
           if (check) {
             return (color_won != 0) ? str(move_num) + ". " + "O-O" + "#" : str(move_num) + ". " + "O-O" + "+";
           }
           else {
             return str(move_num) + ". " + "O-O"; 
           }
       }
       else if (notation_piece.equals("K") && previous_x.equals("e") && notation_col.equals("c")) {
            if (check) {
             return (color_won != 0) ? str(move_num) + ". " + "O-O-O" + "#" : str(move_num) + ". " + "O-O-O" + "+";
           }
           else {
             return str(move_num) + ". " + "O-O-O";
           } 
       }
    else {
      if (check) {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + captures + notation_col + notation_row + promotion_piece + ((color_won != 0) ? "#" : "+");
      }
      else {
        return str(move_num) + ". " + notation_piece + previous_x + previous_y + captures + notation_col + notation_row + promotion_piece;
      }
    }
  }
  
   void print_move(int x_pos, int y_pos) {
     textSize(27); 
     fill(255);
     text(full_move, x_pos, y_pos); 
  }
  
  void HIGHLIGHT_SQUARES() {
    last_moved.assign_visual(true); 
  }
  
}

class MoveList {
  MoveRecord head; 
  MoveRecord tail; 
  
  MoveList() {
    head = null; 
    tail = null; 
  }
  
  //Adds a move to a move list
  void add_move(MoveRecord my_move) {
    if (head == null) {
      head = my_move; 
      tail = my_move; 
    }
    else {
      tail.next = my_move; 
      my_move.prev = tail;
      tail = my_move; 
    }
  }
  
  //Get a move at Specified Index
  MoveRecord get_move_at_index(int index_no) {
  if (head == null) {
    return null;
  }
  MoveRecord stepper = head;   
  while (index_no > 0 && stepper != null) {
    stepper = stepper.next; 
    index_no--; 
  }
  if (index_no != 0) {
    println("The move list specified does not contain a move record at the specified index."); 
  }
  return stepper;
  }
}

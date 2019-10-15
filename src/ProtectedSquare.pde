//DEFENDER NODE CLASS TO BE USED IN THE PROTECTEDSQUARE CLASS
class SquareDefender {
  Piece defending_piece; 
  SquareDefender next; 
  
  SquareDefender (Piece my_piece) {
    defending_piece = my_piece; 
    next = null; 
  }
}

//PROTECTED SQUARE CLASS
class ProtectedSquare {
  int SquareX; 
  int SquareY; 
  SquareDefender primary; 
  
  ProtectedSquare (int x, int y, Piece my_piece) {
    SquareX = x; 
    SquareY = y; 
    primary = new SquareDefender(my_piece);
  }
  
  void add_defender(Piece new_defender) {
  if (primary == null) {
    primary = new SquareDefender(new_defender); 
  }
  else {
    SquareDefender stepper = primary; 
    while (stepper.next != null) {
      stepper = stepper.next; 
    }
    stepper.next = new SquareDefender(new_defender); 
  }
  }
  
  //RETURNS THE NUMBER OF DEFENDERS FOR ONE SIDE ON THIS SQUARE
  int get_defender_count() {
    int count = 0; 
    SquareDefender stepper = primary;
    while (stepper != null) {
      count++; 
    stepper = stepper.next; 
    }
    return count; 
  }
  
  //RETURNS THE PIECE AT THE SPECIFIED INDEX OF THE LIST
  Piece get_defender_at_index(int index_no) {
  if (primary == null) {
    return null;
  }
  SquareDefender stepper = primary;   
  while (index_no > 0) {
    stepper = stepper.next; 
    index_no--; 
  }
  return stepper.defending_piece;
  }
  
  //SORTS THE LIST
  void insertion_sort() {
  //IF PRIMARY IS NOT NULL
  if (primary != null) {
    //STEPPER GETS PRIMARY
    SquareDefender stepper = primary;
    //WHILE STEPPER.NEXT IS NOT NULL
    while (stepper.next != null) {
      //IF THE NEXT PIECE HAS LOWER MATERIAL VALUE THAN THE CURRENT
      if (stepper.next.defending_piece.material_value < stepper.defending_piece.material_value) {
        //STORE THE NEXT PIECE
        SquareDefender my_node = stepper.next;
        //LET THE NEXT PIECE TO THE CURRENT ONE BE THE ONE AFTER
        stepper.next = stepper.next.next;
        //SECONDARY STEPPER IS INITIALIZED TO PRIMARY
        SquareDefender new_stepper = this.primary;
        //IF NEW NODE REPLACES PRIMARY
        if (my_node.defending_piece.material_value < primary.defending_piece.material_value) {
          my_node.next = primary; 
          primary = my_node; 
        }
        else {
          //WHILE MY NODE'S PIECE IS OF GREATER VALUE THAN THE NEXT,
          while (my_node.defending_piece.material_value > new_stepper.next.defending_piece.material_value) {
            //SECONDARY STEPPER GETS THAT PIECE
            new_stepper = new_stepper.next; 
          }
          my_node.next = new_stepper.next; 
          new_stepper.next = my_node; 
        }
      }
      //ELSE CONDITION IS IMPORTANT OTHERWISE SORT WOULD SKIP OVER CURRENT NODE THAT MAY NOT BE SORTED
      else {
        stepper = stepper.next;
      }
    }
  }
  }
  
}

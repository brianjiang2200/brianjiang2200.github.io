int get_eval(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
  int my_eval = CountMaterial(my_board, true) - CountMaterial(my_board, false); 
  return my_eval; 
}

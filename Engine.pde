int get_eval(Piece my_board[][], ProtectedSquare for_white[][], ProtectedSquare for_black[][]) {
  int my_eval = count_white_material(my_board) - count_black_material(my_board); 
  return my_eval; 
}

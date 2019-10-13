void draw() {
  draw_menu(); 
  //display board
  image(boardimg, 0, 0, 800, 800);
  //display highlighted squares
  fill(107,207,227); 
  if (game_active) {
    if (last_moved != null) {
      rect(last_moved.SquareX * 100, last_moved.SquareY * 100, piecedim, piecedim);
    }
  }
  else {
    rect(current_record.last_moved.SquareX * 100, current_record.last_moved.SquareY * 100, piecedim, piecedim); 
  }
  //display pieces
  for (int i = 0; i < 8; ++i) {
    for (int k = 0; k < 8; ++k) {
      if (displayed[i][k] != null) {
        displayed[i][k].display();
      }
    }
  }
}

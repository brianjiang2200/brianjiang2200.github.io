void draw() {
  draw_menu(); 
  //display board
  image(boardimg, 0, 0, 800, 800); 
  //display pieces
  for (int i = 0; i < 8; ++i) {
    for (int k = 0; k < 8; ++k) {
      if (displayed[i][k] != null) {
        displayed[i][k].display();
      }
    }
  }
}

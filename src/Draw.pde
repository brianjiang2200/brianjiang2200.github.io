void draw() {
  draw_menu(); 
  //display board
  image(boardimg, 0, 0, 800, 800);
  //display highlighted squares
  if (game_active) {
    if (last_moved != null) {
      //fill square currently occupied
      fill(dark);
      stroke(dark);
      rect(last_moved.SquareX * 100, last_moved.SquareY * 100, piecedim, piecedim);
      //fill square just left
      fill(light);
      stroke(light);
      rect(main_move_list.tail.previous_x * 100, (8 - main_move_list.tail.previous_y) * 100, piecedim, piecedim);
    }
  }
  else {
    fill(dark);
    stroke(dark);
    rect(current_record.notation_col * 100, current_record.notation_row * 100, piecedim, piecedim);
    fill(light);
    stroke(light);
    rect(current_record.previous_x * 100, (8 - current_record.previous_y) * 100, piecedim, piecedim);
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
  stroke(0); 
  rect(0,800,1400,100);
  fill(255); 
  text("Running Evaluation: " + eval, 30, 860); 
  
  try { 
     if (main_move_list.tail != null && !underpromotion_on) {
         if (main_move_list.tail.move_num < 9) {
           for (MoveRecord my_record = main_move_list.head; (my_record != null && my_record.move_num - main_move_list.tail.move_num < 8); my_record = my_record.next) {
             if (my_record.last_moved.iswhite) {
               my_record.print_move(white_move_list_x, move_list_y - 420 + (my_record.move_num - 1) * 60); 
             }
             else {
               my_record.print_move(black_move_list_x, move_list_y - 420 + (my_record.move_num - 1) * 60); 
             }
           }
         }
         else {
           for (MoveRecord my_record = main_move_list.tail; (my_record != null && main_move_list.tail.move_num - my_record.move_num < 8); my_record = my_record.prev) {
             if (my_record.last_moved.iswhite) {
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

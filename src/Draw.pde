void draw() {
  draw_menu(); 
  //display board
  image(boardimg, 0, 0, Xmap800, Ymap800);
  //display highlighted squares
  if (game_active) {
    if (last_moved != null) {
      //fill square currently occupied
      fill(dark);
      stroke(dark);
      rect(last_moved.SquareX * piecedim, last_moved.SquareY * piecedim, piecedim, piecedim);
      //fill square just left
      fill(light);
      stroke(light);
      rect(main_move_list.tail.previous_x * piecedim, (8 - main_move_list.tail.previous_y) * piecedim, piecedim, piecedim);
    }
  }
  else {
    fill(dark);
    stroke(dark);
    rect(current_record.notation_col * piecedim, current_record.last_moved.SquareY * piecedim, piecedim, piecedim);
    fill(light);
    stroke(light);
    rect(current_record.previous_x * piecedim, (8 - current_record.previous_y) * piecedim, piecedim, piecedim);
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
  fill(25, 25, 25);
  rect(Xmap800,0,Xnorm(600),Ymap800);
  fill(43, 43, 43);
  rect(Xnorm(850),Ynorm(50),Xnorm(400),Ynorm(500));
  textSize(3 * piecedim/10);
  //Black Bar along Lower Level
  fill(0);
  stroke(0); 
  rect(0, Ymap800, width, piecedim);
  //Text in Black Bar
  fill(255); 
  text("Running Evaluation: " + eval, Xnorm(30), Ynorm(860)); 
  
  //PRINTING NOTATION
  try { 
     if (main_move_list.tail != null && !underpromotion_on) {
         if (main_move_list.tail.move_num < 9) {
           for (MoveRecord my_record = main_move_list.head; (my_record != null && my_record.move_num - main_move_list.tail.move_num < 8); my_record = my_record.next) {
             if (my_record.last_moved.iswhite) {
               my_record.print_move(white_move_list_x, move_list_y - Ynorm(420) + (my_record.move_num - 1) * Ynorm(60)); 
             }
             else {
               my_record.print_move(black_move_list_x, move_list_y - Ynorm(420) + (my_record.move_num - 1) * Ynorm(60)); 
             }
           }
         }
         else {
           for (MoveRecord my_record = main_move_list.tail; (my_record != null && main_move_list.tail.move_num - my_record.move_num < 8); my_record = my_record.prev) {
             if (my_record.last_moved.iswhite) {
               my_record.print_move(white_move_list_x, move_list_y + (my_record.move_num - main_move_list.tail.move_num) * Ynorm(60));
             }
             else {
               my_record.print_move(black_move_list_x, move_list_y + (my_record.move_num - main_move_list.tail.move_num) * Ynorm(60)); 
             }
           }
         }
     }
  }
  catch (Exception e) {
     println("Error on printing Move List"); 
  }
  
  if (game_active) {
    if (white_to_move) {
      text("White to move", Xnorm(960), Ynorm(865));
    }
    else {
      text("Black to move", Xnorm(960), Ynorm(865));
    } 
  }
  if (!game_active) {
    if (color_won > 0) {
      textSize(2*piecedim/5); 
      text("0 - 1", Xnorm(1015), Ynorm(865));
    }
    else if (color_won < 0) {
      textSize(2*piecedim/5); 
      text("1 - 0", Xnorm(1015), Ynorm(865));
    }
  else if (underpromotion_on) {
    textSize(3*piecedim/10); 
    text("Select Promotion Piece", Xnorm(895), Ynorm(150));
    if (my_piece.iswhite) {
      image(whiteknightimg, Xnorm(890), MCupper, 7*piecedim/10, 7*piecedim/10); 
      image(whitebishopimg, Xnorm(970), MCupper, 7*piecedim/10, 7*piecedim/10);
      image(whiterookimg, Xnorm(1050), MCupper, 7*piecedim/10, 7*piecedim/10); 
      image(whitequeenimg, Xnorm(1130), MCupper, 7*piecedim/10, 7*piecedim/10);
    }
    else {
      image(blackknightimg, Xnorm(890), MCupper, 7*piecedim/10, 7*piecedim/10); 
      image(blackbishopimg, Xnorm(1020), MCupper, 7*piecedim/10, 7*piecedim/10); 
      image(blackrookimg, Xnorm(1100), MCupper, 7*piecedim/10, 7*piecedim/10); 
      image(blackqueenimg, Xnorm(1180), MCupper, 7*piecedim/10, 7*piecedim/10); 
    }
  }
    else if (game_drawn) {
      textSize(2*piecedim/5); 
      text("1/2 - 1/2", Xnorm(985), Ynorm(865));
    }
    else {
      textSize(27);
      text("Position after", Xnorm(820), Ynorm(865)); 
      current_record.print_move(Xnorm(985), Ynorm(865));   
    }
  }
}

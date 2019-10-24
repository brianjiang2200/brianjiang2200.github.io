void draw() {
  draw_menu(); 
  //display board
  image(boardimg, 0, 0, Xnorm(800), Ynorm(800));
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
  stroke(255);
  strokeWeight(1);
  fill(25, 25, 25);
  rect(Xnorm(800),0,Xnorm(600),Ynorm(800));
  fill(43, 43, 43);
  rect(Xnorm(900),Ynorm(100),Xnorm(400),Ynorm(500));
  //Previous Move Button
  rect(Xnorm(900),Ynorm(600),Xnorm(200),Ynorm(70));
  //Next Move Button
  rect(Xnorm(1100),Ynorm(600),Xnorm(200),Ynorm(70));
  textSize(piecedim/2);
  fill(255);
  //Button Text
  text("<", Xnorm(985), Ynorm(650)); 
  text(">", Xnorm(1185), Ynorm(650));
  textSize(3 * piecedim/10);
  //Black Bar along Lower Level
  fill(0);
  stroke(0); 
  rect(0,Ynorm(800),Xnorm(1400),piecedim);
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
      text("White to move", Xnorm(1010), Ynorm(865));
    }
    else {
      text("Black to move", Xnorm(1010), Ynorm(865));
    } 
  }
  if (!game_active) {
    if (color_won > 0) {
      textSize(2*piecedim/5); 
      text("0 - 1", Xnorm(1065), Ynorm(865));
    }
    else if (color_won < 0) {
      textSize(2*piecedim/5); 
      text("1 - 0", Xnorm(1060), Ynorm(865));
    }
  else if (underpromotion_on) {
    textSize(3*piecedim/10); 
    text("Select Promotion Piece", Xnorm(945), Ynorm(150));
    if (my_piece.iswhite) {
      image(whiteknightimg, Xnorm(940), Ynorm(200), Xnorm(70), Ynorm(70)); 
      image(whitebishopimg, Xnorm(1020), Ynorm(200), Xnorm(70), Ynorm(70));
      image(whiterookimg, Xnorm(1100), Ynorm(200), Xnorm(70), Ynorm(70)); 
      image(whitequeenimg, Xnorm(1180), Ynorm(200), Xnorm(70), Ynorm(70));
    }
    else {
      image(blackknightimg, Xnorm(940), Ynorm(200), Xnorm(70), Ynorm(70)); 
      image(blackbishopimg, Xnorm(1020), Ynorm(200), Xnorm(70), Ynorm(70)); 
      image(blackrookimg, Xnorm(1100), Ynorm(200), Xnorm(70), Ynorm(70)); 
      image(blackqueenimg, Xnorm(1180), Ynorm(200), Xnorm(70), Ynorm(70)); 
    }
  }
    else if (game_drawn) {
      textSize(2*piecedim/5); 
      text("1/2 - 1/2", Xnorm(1035), Ynorm(865));
    }
    else {
      textSize(27);
      text("Position after", Xnorm(870), Ynorm(865)); 
      current_record.print_move(Xnorm(1035), Ynorm(865));   
    }
  }
}

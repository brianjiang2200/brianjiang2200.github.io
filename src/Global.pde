//IMPORTS

//IMAGES

//Board Image
PImage boardimg;
 
//White piece images
PImage whitepawnimg, whiteknightimg, whitebishopimg, whitekingimg, whitequeenimg, whiterookimg;

//Black piece images
PImage blackpawnimg, blackknightimg, blackbishopimg, blackkingimg, blackqueenimg, blackrookimg;


//SKETCH PROPERTIES 

//Piece on-screen dimensions
int piecedim = 100;

//Main board move number 
int move_number = 1; 

//Position Evaluation
float eval = 0; 

//Side to Move: true if white to move, false if black to move
boolean white_to_move = true; 

//Piece is currently selected by user
boolean piece_selected = false; 

//Additional moves can currently be made on the board 
boolean game_active = true; 

//Game is over (a result has been reached)
boolean game_over = false; 

//Determines outcome of game. 1 for white win, -1 for black win, 0 otherwise. 
int color_won = 0; 

//Game is drawn
boolean game_drawn = false; 

//Underpromotion Menu On? 
boolean underpromotion_on = false; 

//Currently selected piece and last piece to complete a move. 
Piece my_piece, last_moved;  

//White King, Black King, and Kings for determining when in check in variations
King white_king, black_king, copy_white_king, copy_black_king; 

//String Array Containing all opening Positions from Positions_Repo.txt
String[] read_positions_repo; 

//Main Board Squares Protected by White 
ProtectedSquare[][] white_protected_squares = new ProtectedSquare[8][8];

//Main Board Squares Protected by Black 
ProtectedSquare[][] black_protected_squares = new ProtectedSquare[8][8];

//Main Board
Piece[][] piece_board = new Piece[8][8]; 

//Displayed Board
Piece[][] displayed = new Piece[8][8]; 

//Main Move List 
MoveList main_move_list = new MoveList(); 

//When cycling through moves, current Move Record
MoveRecord current_record; 

//Menu Display Parameters 
int white_move_list_x = 920; 
int black_move_list_x = 1120; 
int move_list_y = 570; 

//ARRAYS FOR SQUARES PROTECTED BY PIECES

//Knight 
int[][] KnightSquares = {{-2,-1},{-1,-2},{1,-2},{2,-1},{2,1},{1,2},{-1,2},{-2,1}}; 

//King 
int[][] KingSquares = {{-1,-1},{0,-1},{1,-1},{1,0},{1,1},{0,1},{-1,1},{-1,0}}; 

//X COORDINATE CONVERSIONS
//Integer Dictionary for Letters to Numbers
IntDict XtoNum;

//Array for Numbers to Letters
String[] XtoLet;

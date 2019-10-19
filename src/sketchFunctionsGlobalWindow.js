var pjsInstance; 

function startSketch(sketchname) {
	switchSketchState(true, sketchname); 
}

function stopSketch(sketchname) {
	switchSketchState(false, sketchname); 
}

function switchSketchState(on, sketchname) {
	pjsInstance = Processing.getInstanceById(sketchname); 
	if (on) {
		pjsInstance.loop(); 
	}
	else {
		pjsInstance.noLoop(); 
	}
}

function switchOpening(sketchname, openingname) {
	pjsInstance = Processing.getInstanceById(sketchname);
	try {
		pjsInstance.load_opening_positions(); 
		pjsInstance.generate_piece_positions(pjsInstance.get_position(openingname)); 
	}
	catch(error) {
		console.error(error); 
	}
}	
	
function flipBoard() {
	pjsInstance = Processing.getInstanceById(sketchname); 
	try {
		pjsInstance.flipBoard(); 
	}
	catch(error) {
		console.error(error); 
	}
}

function deleteMove() {
	pjsInstance = Processing.getInstanceById(sketchname); 
	try {
		if (pjsInstance.game_active) {
			pjsInstance.main_move_list.deleteMoveRecord(pjsInstance.main_move_list.tail);
			pjsInstance.current_record = pjsInstance.main_move_list.tail; 
			pjsInstance.piece_board = pjsInstance.current_record.stored_position;
			pjsInstance.displayed = pjsInstance.piece_board;
			pjsInstance.white_to_move = !current_record.last_moved.iswhite; 
		}
		else {
			pjsInstance.main_move_list.deleteMoveRecord(pjsInstance.current_record);
			pjsInstance.current_record = pjsInstance.main_move_list.tail; 
			pjsInstance.piece_board = pjsInstance.main_move_list.tail.stored_position;
			pjsInstance.displayed = pjsInstance.piece_board;
			pjsInstance.white_to_move = !current_record.last_moved.iswhite;
			pjsInstance.game_active = true; 
		}
	}
	catch(error) {
		console.error(error); 
	}
}
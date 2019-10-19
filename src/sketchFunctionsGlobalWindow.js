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

function deleteMove(sketchname) {
	pjsInstance = Processing.getInstanceById(sketchname); 
	try {
		pjsInstance.removeVariation(pjsInstance.main_move_list, pjsInstance.current_record); 
	}
	catch(error) {
		console.error(error) 
	}
}
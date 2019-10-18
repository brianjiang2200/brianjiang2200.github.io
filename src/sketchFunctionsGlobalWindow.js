var pjsInstance; 

function startSketch() {
	switchSketchState(true); 
}

function stopSketch() {
	switchSketchState(false); 
}

function switchSketchState(on, sketchname) {
	pjsInstance = Processing.getInstancebyId(sketchname); 
	if (on) {
		pjsInstance.loop(); 
	}
	else {
		pjsInstance.noLoop(); 
	}
}

function switchOpening(sketchname, openingname) {
	pjsInstance = Processing.getInstancebyId(sketchname);
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
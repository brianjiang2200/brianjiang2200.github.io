var pjsInstance; 

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
	
function flipBoard(sketchname) {
	pjsInstance = Processing.getInstanceById(sketchname); 
	try {
		pjsInstance.flipBoard(); 
	}
	catch(error) {
		console.error(error); 
	}
}

function resetBoard(sketchname) {
	pjsInstance = Processing.getInstanceById(sketchname);
	try {
		pjsInstance.resetSketch();
	}
	catch(error) {
		console.error(error); 
	}
}
function deleteMove(sketchname) {
	pjsInstance = Processing.getInstanceById(sketchname);
	try {
		pjsInstance.removeVariation();  
	}
	catch(error) {
		console.error(error); 
	}
}
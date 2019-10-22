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

function returnOpeningOptions(sketchname) {
	pjsInstance = Processing.getInstanceById(sketchname); 
	try {
		return pjsInstance.returnOpeningNames(pOpeningName); 
	}
	catch(error) {
		console.error(error); 
	}
}

function displayOpeningOptions(sketchname, openingHtmlList, inputID) {
	var input, filter, ul, li, a, txtValue, i; 
	input = document.getElementById(inputID);
	filter = input.value.toUpperCase();
	ul = document.getElementById(openingHtmlList); 
	li = ul.getElementsByTagName("li"); 
	for (i = 0; i < li.length; ++i) {
		a = li[i].getElementsByTagName("a")[0]; 
		txtValue = a.textContent || a.innerText; 
		if (txtValue.toUpperCase().indexOf(filter) > -1) {
			li[i].style.display=""; 
		}
		else {
			li[i].style.display = "none"; 
		}
	}
}

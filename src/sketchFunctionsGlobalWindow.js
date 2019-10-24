var pjsInstance;
var OpeningPositionsList;

function switchOpening(sketchname, openingname) {
	pjsInstance = Processing.getInstanceById(sketchname);
	try { 
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
		OpeningPositionsList = pjsInstance.returnOpeningNames(); 
	}
	catch(error) {
		console.error(error); 
	}
}

function generateOpeningsListonWindow(ultitle) {
		for (var i = 0; i < OpeningPositionsList.length; ++i) {
		var node = document.createElement("LI"); 
		var textnode = document.createTextNode(OpeningPositionsList[i]); 
		node.appendChild(textnode);
		node.classList.add('card');
		node.classList.add('bg-info'); 
		node.classList.add('text-white'); 
		document.getElementById(ultitle).appendChild(node);
	}
}

function displayOpeningOptions(openingHtmlList, inputID) {
	var input, filter, ul, li, a, txtValue, i; 
	input = document.getElementById(inputID);
	filter = input.value.toUpperCase();
	ul = document.getElementById(openingHtmlList); 
	li = ul.getElementsByTagName("li"); 
	for (i = 0; i < li.length; ++i) { 
		txtValue = li[i].textContent || li[i].innerText; 
		if (txtValue.toUpperCase().indexOf(filter) > -1) {
			li[i].style.display="";
			li[i].onclick = switchOpening('sketch', li[i].innerText);
		}
		else {
			li[i].style.display = "none"; 
		}
	}
}

function getSketchWidth(sketchname) {
	return document.getElementById(sketchname).width; 
}

function getSketchHeight(sketchname) {
	return document.getElementById(sketchname).height; 
}

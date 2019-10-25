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
		console.log(OpeningPositionsList[i]);
		var node = document.createElement("BUTTON"); 
		var textnode = document.createTextNode(OpeningPositionsList[i]); 
		node.appendChild(textnode);
		node.classList.add('btn');
		node.classList.add('btn-success'); 
		node.classList.add('text-white');
		node.style.display = "none"; 
		document.getElementById(ultitle).appendChild(node);
	}
}

function displayOpeningOptions(openingHtmlList, inputID) {
	var input, filter, ul, li, a, txtValue, i; 
	input = document.getElementById(inputID);
	filter = input.value.toUpperCase();
	ul = document.getElementById(openingHtmlList); 
	li = ul.getElementsByTagName("button"); 
	for (i = 0; i < li.length; ++i) { 
		txtValue = li[i].textContent || li[i].innerText;
		if (!(filter === "") && txtValue.toUpperCase().indexOf(filter) > -1) {
			let result = txtValue;
			li[i].style.display = "block";
			li[i].addEventListener("click", function() {switchOpening('sketch', result)});
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

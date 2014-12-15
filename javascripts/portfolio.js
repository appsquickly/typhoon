$(document).ready(function() {

  // Setting up our variables
	var $filter;
	var $container;
	var $containerClone;
	var $filterLink;
	var $filteredItems
	
	// Set our filter
	$filter = $('.filterOptions li.active a').attr('class');
	
	// Set our filter link
	$filterLink = $('.filterOptions li a');
	
	// Set our container
	$container = $('ul.ourHolder');
	
	// Clone our container
	$containerClone = $container.clone();
 
	// Apply our Quicksand to work on a click function
	// for each of the filter li link elements
	$filterLink.click(function(e) 
	{
		e.preventDefault(); // stop anchor tags from doing anything
		// Remove the active class
		$('.filterOptions li').removeClass('active');
		
		// Split each of the filter elements and override our filter
		$filter = $(this).attr('class').split(' ');
		
		// Apply the 'active' class to the clicked link
		$(this).parent().addClass('active');
		
		// If 'all' is selected, display all elements
		// else output all items referenced by the data-type
		if ($filter == 'all') {
			$filteredItems = $containerClone.find('li'); 
		}
		else {
			$filteredItems = $containerClone.find('li[data-type~=' + $filter + ']'); 
		}
		
		// Finally call the Quicksand function
		$container.quicksand($filteredItems, 
		{
			// The duration for the animation
			duration: 750,
			// The easing effect when animating
			easing: 'easeInOutCirc',
			// Height adjustment set to dynamic
			adjustHeight: 'dynamic' 
		});
	});
});
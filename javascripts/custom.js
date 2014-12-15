
// Website Loadier Animation
$(window).load(function() {
	$("#loading").fadeOut("1000", function() {
		// Animation complete
		$('#loading img').css("display","none");
		$('#loading').css("display","none");
		$('#loading').css("background","none");
		$('#loading').css("width","0");
		$('#loading').css("height","0");
	});
	$('h1').delay(1000).animate({marginTop:'0px',opacity: '1' }, { duration: 544});
	$('.photo-background').delay(1200).animate({marginTop:'0px',opacity: '1' }, { duration: 544});
	$('.video-background').delay(1400).animate({marginTop:'0px',opacity: '1' }, { duration: 544});
});

$(function() {
	$('ul.right a').bind('click',function(event){
		var $anchor = $(this);
				
		$('html, body').stop().animate({
			scrollTop: $($anchor.attr('href')).offset().top
		}, 2000,'easeInOutQuart');
				
		event.preventDefault();
	});
	
	$('.middle-column a').bind('click',function(event){
		var $anchor = $(this);
				
		$('html, body').stop().animate({
			scrollTop: $($anchor.attr('href')).offset().top
		}, 3000,'easeInOutQuart');
				
		event.preventDefault();
	});
	
	$('.bottom-icon a').bind('click',function(event){
		var $anchor = $(this);
				
		$('html, body').stop().animate({
			scrollTop: $($anchor.attr('href')).offset().top
		}, 3000,'easeInOutQuart');
				
		event.preventDefault();
	});
			
	$('.name a').bind('click',function(event){
		var $anchor = $(this);
				
		$('html, body').stop().animate({
			scrollTop: $($anchor.attr('href')).offset().top
		}, 3000,'easeInOutQuart');
				
		event.preventDefault();
	});
});

function moveTo(contentArea){
	var goPosition = $(contentArea).offset().top;
	$('html, body').stop().animate({
		scrollTop: goPosition
	}, 2000,'easeInOutQuart');
}

$(window).scroll(function() {    
	$(".main-menu a.selected").removeClass("selected");
	var scroll = $(window).scrollTop();
	if (scroll <= 800) {
		$(".main-menu .first").addClass("selected");
	}
	else if (scroll <= 2000) {
		$(".main-menu .second").addClass("selected");
	}
	else if (scroll <= 3500) {
		$(".main-menu .third").addClass("selected");
	}
	else if (scroll <= 10000) {
		$(".main-menu .fourth").addClass("selected");
	}
});
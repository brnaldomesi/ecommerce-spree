var selectedSetOfVariantIds = [];
var selectedVariantId;
function selectOptionValue(e) {
	var data = $(this).attr('data');
	if (data && data != "") {
	  $('.option-value-button').removeClass('btn-current');
	  $(this).addClass('btn-current');
	  selectedSetOfVariantIds = data.split(" ");
	  if (typeof(refreshImageAndThumbnails) == 'function'){ refreshImageAndThumbnails(selectedSetOfVariantIds[0] ); }
	  if (selectedSetOfVariantIds.length == 1) {
	    selectedVariantId = selectedSetOfVariantIds[0];
	    document.forms["cart_form"]["variant_id"].value = selectedVariantId;
	  }
	  $(".secondary-option-type-row .option-value-button").each(function(idx){
	    var otherData = $(this).attr('data');
	    var otherVariantIds = otherData.split(' ');
	    var commonVariantIds = otherVariantIds.filter(value => selectedSetOfVariantIds.includes(value));
	    if (commonVariantIds.length < 1) {
	      $(this).removeClass('btn-available').addClass('btn-unavailable');
	    } else {
	      $(this).removeClass('btn-unavailable').addClass('btn-available');
	    }
	    // console.log("* has "+ variantId +"? " + otherVariantIds);
	  });
	}
}

function selectSecondaryOptionValue(e) {
	var data = $(this).attr('data');
	if (data && data != "") {
	  var curVariantIds = data.split(" ");
	  var commonVariantIds = curVariantIds.filter(value => selectedSetOfVariantIds.includes(value));
	  selectedVariantId = commonVariantIds[0];
	  document.forms["cart_form"]["variant_id"].value = selectedVariantId;
	  console.log("| selected: " + selectedSetOfVariantIds +" vs cur " + curVariantIds );
	  console.log("| selectedVariantId = "+ selectedVariantId );
	}
}

function activateVariant(e) {
  var variantId = $(this).attr('value');
  //console.log('Variant ID: ' + variantId);
  refreshImageAndThumbnails(variantId);
}

function refreshImageAndThumbnails(variantId) {
  $('.vtmb').addClass('tmb-inactive');
  $('.tmb').addClass('tmb-inactive');
  $('.tmb-all').removeClass('tbm-inactive').addClass('tmb-active');
  $('.tmb-' + variantId).removeClass('tmb-inactive').addClass('tmb-active');
  var firstThumb = $('.tmb-' + variantId)[0];
}

function loadImageOfThumbnail(e) {
  e.preventDefault();
  $(".product-gallery > img").attr("src", $(this).attr('href') );
}

$(document).ready(function(){
	$(".owl-carousel").owlCarousel({ 
	    navigation : true,
	    items: 1,
	    loop: true
	  });

	$('.color-box').click(function(){
		$('.color-box').removeClass('selected');
		$(this).addClass('selected');
		name = $(this).attr('data-name');
		$(this).parent().find('.selected-value').html(': ' + name);
		str = $(this).attr('data');
		var_ids = str.split(' ');
		$('.product-thumbnails .tmb-all').addClass('unavailable');
		var_ids.forEach(function(e) {
			$('.tmb-' + e).removeClass('unavailable');
		});
	});

	$('.option-type-row button').click(function() {
		parent = $(this).parent();
		parent.children().removeClass('selected');
		$(this).addClass('selected');
	});

	$('.btn.show-more').click(function() {
		$('.gallery-image.hidden').removeClass('hidden');
		$(this).hide();
	})

	$('#option_type_row_1 .option-value-button').click(selectOptionValue);
	$('.secondary-option-type-row .option-value-button').click(selectSecondaryOptionValue);
})


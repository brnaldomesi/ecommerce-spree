// Debounced resize event (width only). [ref: https://paulbrowne.xyz/debouncing]
var _resize = function (a, b) {
  var c = [window.innerWidth]
  return window.addEventListener('resize', function () {
    var e = c.length
    c.push(window.innerWidth)
    if (c[e] !== c[e - 1]) {
      clearTimeout(b)
      b = setTimeout(a, 150)
    }
  }), a
}

// Bootstrap BreakPoint Checker
var breakPoint = function (value) {
  var el, check, cls
  
  switch (value) {
    case 'xs':
      cls = 'd-none d-sm-block'
      break
    case 'sm':
      cls = 'd-block d-sm-none d-md-block'
      break
    case 'md':
      cls = 'd-block d-md-none d-lg-block'
      break
    case 'lg':
      cls = 'd-block d-lg-none d-xl-block'
      break
    case 'xl':
      cls = 'd-block d-xl-none'
      break
  }

  el = $('<div/>', {
    'class': cls
  }).appendTo('body')

  check = el.is(':hidden')
  el.remove()

  return check
}
var xs = function () {
  return breakPoint('xs')
}
var sm = function () {
  return breakPoint('sm')
}
var md = function () {
  return breakPoint('md')
}
var lg = function () {
  return breakPoint('lg')
}
var xl = function () {
  return breakPoint('xl')
}

$(function () {
  var body = $('body')
  var mainContainer = $('#main-container')

  // This is for development, attach breakpoint to document title
  /*var docTitle = document.title
  _resize(function () {
    if (xs()) {
      document.title = '(xs) ' + docTitle
    } else if (sm()) {
      document.title = '(sm) ' + docTitle
    } else if (md()) {
      document.title = '(md) ' + docTitle
    } else if (lg()) {
      document.title = '(lg) ' + docTitle
    } else if (xl()) {
      document.title = '(xl) ' + docTitle
    }
  })()*/

  // Form search, prevent submit on empty value
  $('.form-search').submit(function (event) {
    var searchInput = $(this).find('input')
    if (searchInput.val() == '') {
      searchInput.focus()
      event.preventDefault()
    }
  })

  // Perfect Scrollbar for main sidebar
  var psSidebar = new PerfectScrollbar('#main-sidebar', { wheelPropagation: false })

  // MORE & LESS toggle
  $('#main-sidebar .toggle').click(function () {
    var toggler = $(this)
    if (toggler.attr('aria-expanded') == 'true') {
      toggler.html('MORE &#9662;')
    } else {
      toggler.html('LESS &#9652;')
    }
  })

  // Update Perfect Scrollbar
  $('#main-sidebar .collapse').on('shown.bs.collapse', function () {
    psSidebar.update()
  })
  $('#main-sidebar .collapse').on('hidden.bs.collapse', function () {
    psSidebar.update()
  })

  // Toggle sidebar collapse (md down)
  $('.toggle-menu').click(function () {
    mainContainer.toggleClass('sidebar-collapse')
    if (!lg() && !xl() && !mainContainer.hasClass('sidebar-collapse')) {
      body.addClass('modal-open').append('<div class="sidebar-backdrop"></div>')
    } else {
      body.removeClass('modal-open').find('.sidebar-backdrop').remove()
    }
    $(document).trigger('sidebar.changed')
  })

  // Force to collapse sidebar on md down
  _resize(function () {
    if (!lg() && !xl()) {
      mainContainer.addClass('sidebar-collapse')
      $('body').removeClass('modal-open').find('.sidebar-backdrop').remove()
      $(document).trigger('sidebar.changed')
    } else {
      mainContainer.removeClass('sidebar-collapse')
      $(document).trigger('sidebar.changed')
    }
  })()

  // Close sidebar when clicked outside sidebar
  $(document).on('click', '.sidebar-backdrop', function (event) {
    $('.toggle-menu').trigger('click')
    event.preventDefault()
  })

  // Toggle Search Form
  $('#search-toggle').click(function (event) {
    $('.form-search').toggleClass('d-none').find('.form-control').focus()
    event.preventDefault()
  })
  $('.btn-search-back').click(function (event) {
    $('.form-search').toggleClass('d-none')
    event.preventDefault()
  })

})

$(function () {
  // Rating Icons
  $('.rating').each(function () {
    var value = $(this).data('value')
    for (var i = 0; i < Math.floor(value); i++) {
      $(this).append('<i class="fa fa-star"></i>\n')
    }
    if (value % 1 != 0) {
      $(this).append('<i class="fa fa-star-half-o"></i>\n')
    }
    var total = $(this).find('i.fa').length
    if (total < 5) {
      for (var x = 0; x < (5 - total); x++) {
        $(this).append('<i class="fa fa-star-o"></i>\n')
      }
    }
  })

  // Background Cover
  var cover = function () {
    $('[data-cover]').each(function () {
      var cover = $(this)
      cover.css('background-image', 'url(' + decodeURIComponent(cover.data('cover')) + ')')
      cover.attr('data-height') && cover.css('height', cover.data('height'))
      if (xs()) {
        cover.attr('data-xs-height') && cover.css('height', cover.data('xs-height'))
      } else if (sm()) {
        cover.attr('data-sm-height') && cover.css('height', cover.data('sm-height'))
      } else if (md()) {
        cover.attr('data-md-height') && cover.css('height', cover.data('md-height'))
      } else if (lg()) {
        cover.attr('data-lg-height') && cover.css('height', cover.data('lg-height'))
      } else if (xl()) {
        cover.attr('data-xl-height') && cover.css('height', cover.data('xl-height'))
      }
    })
  }
  _resize(function () {
    cover()
  })()

  // Home Slider
  if ($('#home-slider').length && typeof Swiper !== 'undefined') {
    var homeSlider = new Swiper('#home-slider', {
      loop: true,
      navigation: {
        prevEl: '#home-slider-prev',
        nextEl: '#home-slider-next'
      },
      autoplay: {
        delay: 3000,
        disableOnInteraction: false
      }
    })
    $(document).on('sidebar.changed', function () {
      homeSlider.update()
    })
  }

  // Categories Slider
  if ($('#categories-slider').length && typeof Swiper !== 'undefined') {
    var categoriesSlider = new Swiper('#categories-slider', {
      navigation: {
        prevEl: '#categories-slider-prev',
        nextEl: '#categories-slider-next'
      }
    })
    $(document).on('sidebar.changed', function () {
      categoriesSlider.update()
    })
  }

  // Popular Slider
  if ($('#popular-slider').length && typeof Swiper !== 'undefined') {
    var popularSlider = new Swiper('#popular-slider', {
      navigation: {
        prevEl: '#popular-slider-prev',
        nextEl: '#popular-slider-next'
      }
    })
    $(document).on('sidebar.changed', function () {
      popularSlider.update()
    })
  }

  // Brands Slider
  if ($('#brands-slider').length && typeof Swiper !== 'undefined') {
    var brandsSlider = new Swiper('#brands-slider', {
      navigation: {
        prevEl: '#brands-slider-prev',
        nextEl: '#brands-slider-next'
      }
    })
    $(document).on('sidebar.changed', function () {
      brandsSlider.update()
    })
  }

  // Price Range Slider
  if ($('#price-range').length) {
    var priceRange = document.getElementById('price-range')
    noUiSlider.create(priceRange, {
      start: [150, 750],
      connect: true,
      tooltips: [true, true],
      range: {
        'min': 0,
        'max': 1000
      }
    })
  }
  // Rating Range Slider
  if ($('#star-rating').length) {
    $('#star-rating').raty({
      half: true,
      score: function () {
        return $(this).attr('data-score')
      }
    })
  }

  // Show large image on hover
  $('.img-detail-list a').mouseenter(function () {
    var src = $(this).find('img').data('large-src')
    var dataIndex = $(this).find('img').data('index')
    $('#img-detail').attr('src', src)
    $('#img-detail').data('index', dataIndex)
    $(this).siblings().removeClass('active')
    $(this).addClass('active')
  })
  $('.img-detail-list a').click(function (event) {
    event.preventDefault()
  })

  // Photoswipe
  var parseThumbnailElements = function () {
    var items = []
    $('.img-detail-list img').each(function () {
      item = {
        src: $(this).data('large-src'),
        w: 1000,
        h: 850
      }
      items.push(item)
    })
    return items
  }
  var openPhotoSwipe = function (activeIndex) {
    activeIndex = typeof activeIndex !== 'undefined' ? activeIndex : 0
    var pswpElement = document.querySelectorAll('.pswp')[0]
    var items = parseThumbnailElements()
    var options = {
      index: activeIndex
    }
    var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, items, options)
    gallery.init()
  }
  $('#img-detail').click(function (event) {
    openPhotoSwipe($(this).data('index'))
  })

  // Spinner for quantity input
  $('.input-spinner').each(function () {
    var input = $(this).find('input[type="number"]')

    var min = input.attr('min')

    var max = input.attr('max')

    var btnIncrease = $(this).find('.btn:first-child')

    var btnDecrease = $(this).find('.btn:last-child')
    btnIncrease.click(function () {
      if (input.val() < max) {
        input.val(parseInt(input.val()) + 1).trigger('change')
      }
    })
    btnDecrease.click(function () {
      if (input.val() > min) {
        input.val(parseInt(input.val()) - 1).trigger('change')
      }
    })
  })

  // Credit Card Form
  if ($('#card').length) {
    $('#card').card({
      container: '.card-wrapper'
    })
  }
})

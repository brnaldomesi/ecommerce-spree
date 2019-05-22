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
    case 'smDown':
      cls = 'd-none d-md-block'
      break
    case 'mdDown':
      cls = 'd-none d-lg-block'
      break
    case 'lgDown':
      cls = 'd-none d-xl-block'
      break
    case 'smUp':
      cls = 'd-block d-sm-none'
      break
    case 'mdUp':
      cls = 'd-block d-md-none'
      break
    case 'lgUp':
      cls = 'd-block d-lg-none'
      break
  }

  el = $('<div/>', {
    'class': cls
  }).appendTo('body')

  check = el.is(':hidden')
  el.remove()

  return check
}
var xs     = function () { return breakPoint('xs') }
var sm     = function () { return breakPoint('sm') }
var md     = function () { return breakPoint('md') }
var lg     = function () { return breakPoint('lg') }
var xl     = function () { return breakPoint('xl') }
var smDown = function () { return breakPoint('smDown') }
var mdDown = function () { return breakPoint('mdDown') }
var lgDown = function () { return breakPoint('lgDown') }
var smUp   = function () { return breakPoint('smUp') }
var mdUp   = function () { return breakPoint('mdUp') }
var lgUp   = function () { return breakPoint('lgUp') }

// This is for development, attach breakpoint to document title
var docTitle = document.title
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
})()

$(function () {

  var menu = $('#menu').metisMenu()
  menu.on('show.metisMenu', function () {
    $('.no-sub').removeClass('mm-active')
  })

  var body = $('body'),
      searchForm = $('.form-search'),
      searchInput = $('.input-search')

  // Preventing form from submitting if input is empty
  searchForm.submit(function (event) {
    if (searchInput.val() == '') {
      searchInput.focus()
      event.preventDefault()
    }
  })

  // Add border-primary when search input focused
  searchInput.focus(function () {
    $(this).closest('.input-group').addClass('border-primary')
  }).blur(function () {
    $(this).closest('.input-group').removeClass('border-primary')
  })

  // Toggle search form
  $('.search-toggle').click(function (event) {
    searchForm.toggleClass('d-none')
    searchForm.is(':not(:hidden)') && searchInput.focus()
    event.preventDefault()
  })

  // Sticky Header
  var stickyHeader = function () {
    var header = $('header'),
        wrapper = $('<div id="wrapper"></div>')
    header.before(wrapper)
    var ost = wrapper.offset().top,
        fixedCls = 'fixed-top',
        lastScroll = $(window).scrollTop()
    $(window).scroll(function () {
      var headerHeight = header.outerHeight(),
          scrollTop = $(this).scrollTop()
      if (scrollTop < lastScroll) {
        if (scrollTop <= ost) {
          header.hasClass(fixedCls) && header.removeClass(fixedCls)
          wrapper.height(0)
        }
      } else {
        if (scrollTop >= ost + headerHeight + 20) {
          header.addClass(fixedCls)
          wrapper.height(headerHeight)
        }
      }
      lastScroll = scrollTop
    }).scroll()
  }
  stickyHeader()

  // Offcanvas menu modal
  var offCanvas = function () {
    var menuModal = $('#menuModal')
    menuModal.on('show.bs.modal', function () {
      body.addClass('transparent-backdrop') // add transparent backdrop
    })
    menuModal.on('hidden.bs.modal', function () {
      body.removeClass('transparent-backdrop') // remove transparent backdrop
      $(this).css('display', 'block') // keep showing modal
      var thisTimeout = parseFloat(menuModal.find('.modal-dialog').css('transition-duration')) * 1000 // get dialog transition duration
      setTimeout(function () {
        menuModal.css('display', 'none') // hide modal after dialog transition
      }, thisTimeout)
    })
  }
  offCanvas()

  // Close menu on large devices
  _resize(function () {
    if (lgUp()) {
      $('#menuModal').modal('hide')
    }
  })()

})

feather.replace() // feather icon

var App = {

  // Background Cover
  cover: function () {
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
  },

  // Just add 'show' class to dropdown hover (note, dropdown hover is done by css)
  dropdownHover: function () {
    $('.dropdown-hover').hover(function () {
      if (lgUp()) {
        $(this).addClass('show')
      }
    }, function () {
      if (lgUp()) {
        $(this).removeClass('show')
      }
    })
  },

  // Redirect forwardable dropdown toggle
  forwardable: function () {
    $('.forwardable').click(function () {
      $(this).dropdown('toggle') // prevent dropdown showing
      location.href = this.href
    })
  },

  // Star Rating
  rating: function () {
    $('.rating').each(function () {
      var value = $(this).data('value')
      if (value !== undefined) {
        for (var i = 0; i < Math.floor(value); i++) {
          // Star full
          $(this).append('<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 32 32"><title>star-full</title><path d="M32 12.408l-11.056-1.607-4.944-10.018-4.944 10.018-11.056 1.607 8 7.798-1.889 11.011 9.889-5.199 9.889 5.199-1.889-11.011 8-7.798z"></path></svg>\n')
        }
        if (value % 1 != 0) {
          // Star half
          $(this).append('<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 32 32"><title>star-half</title><path d="M32 12.408l-11.056-1.607-4.944-10.018-4.944 10.018-11.056 1.607 8 7.798-1.889 11.011 9.889-5.199 9.889 5.199-1.889-11.011 8-7.798zM16 23.547l-0.029 0.015 0.029-17.837 3.492 7.075 7.807 1.134-5.65 5.507 1.334 7.776-6.983-3.671z"></path></svg>\n')
        }
        var total = $(this).find('svg').length
        if (total < 5) {
          for (var x = 0; x < (5 - total); x++) {
            // Star empty
            $(this).append('<svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 32 32"><title>star-empty</title><path d="M32 12.408l-11.056-1.607-4.944-10.018-4.944 10.018-11.056 1.607 8 7.798-1.889 11.011 9.889-5.199 9.889 5.199-1.889-11.011 8-7.798zM16 23.547l-6.983 3.671 1.334-7.776-5.65-5.507 7.808-1.134 3.492-7.075 3.492 7.075 7.807 1.134-5.65 5.507 1.334 7.776-6.983-3.671z"></path></svg>\n')
          }
        }
      }
    })
  },

  // Spinner for quantity input
  spinner: function () {
    $('.spinner').each(function () {
      var input = $(this).find('input[type="number"]')
      var min = input.attr('min')
      var max = input.attr('max')
      var btnIncrease = $(this).find('.btn:last-child')
      var btnDecrease = $(this).find('.btn:first-child')
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
  },

  // Home Slider
  homeSlider: function (el) {
    var slider = new Swiper(el, {
      loop: true,
      pagination: {
        el: '.swiper-pagination',
        clickable: true
      },
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      autoplay: {
        delay: 3000,
        disableOnInteraction: false
      },
      on: {
        init: function () {
          setTimeout(function () {
            $(el + ' .swiper-slide-active .animated').each(function () {
              $(this).addClass($(this).data('animate')).addClass('visible')
            })
          }, 100)
        }
      }
    })
    slider.on('slideChange', function () {
      slider.slides.find('.animated').each(function () {
        $(this).removeClass($(this).data('animate')).removeClass('visible')
      })
      $(slider.slides[slider.activeIndex]).find('.animated').each(function () {
        $(this).addClass($(this).data('animate')).addClass('visible')
      })
    })
  },

  // Deals Slider
  dealsSlider: function (el) {
    var dealsSlider = new Swiper(el, {
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      slidesPerView: 2,
      breakpoints: {
        575: { // xs
          slidesPerView: 1,
        }
      }
    })
  },

  // Add to Cart Demo
  atcDemo: function () {
    $('.atc-demo').click(function (event) {
      var product = $(this).data('title') ? $(this).data('title') : $(this).closest('.card').find('.card-title').text()
      new Noty({
        type: 'success',
        text: '<div class="media">\
                <i data-feather="check-circle"></i>\
                <div class="media-body ml-3">\
                  <strong>' + product + '</strong><br/>Successfully added to cart!.\
                </div>\
              </div>',
        timeout: 2000
      }).show()
      feather.replace()
      event.preventDefault()
    })
  },

  // Add to Wishlist Demo
  atwDemo: function () {
    $('.atw-demo').click(function (event) {
      var button = $(this)
      var product = button.closest('.card').find('.card-title').text()
      var caption = button.hasClass('active') ? 'removed from' : 'added to'
      new Noty({
        type: 'pink',
        text: '<div class="media">\
                  <i data-feather="heart"></i>\
                  <div class="media-body ml-3">\
                    <strong>' + product + '</strong><br/>Successfully ' + caption + ' wishlist!.\
                  </div>\
                </div>',
        timeout: 2000
      }).show()
      feather.replace()
      button.hasClass('active') ? button.attr('title', 'Add to wishlist') : button.attr('title', 'Added to wishlist')
      button.hasClass('active') ? button.removeClass('active') : button.addClass('active')
      button.trigger('mouseout')
      event.preventDefault()
    })
  },

  // Quick view Demo
  quickviewDemo: function () {
    $('.quickview-demo').click(function (event) {
      $('#quickviewModal').modal('show')
      event.preventDefault()
    })
  },

  // Add or remove class based on bootstrap breakpoints
  addClassOn: function (breakpoint) {
    $('[data-addclass-on-'+breakpoint+']').each(function () {
      $(this).addClass($(this).data('addclass-on-'+breakpoint))
    })
  },
  returnAddClassOn: function (breakpoint) {
    $('[data-addclass-on-'+breakpoint+']').each(function () {
      $(this).removeClass($(this).data('addclass-on-'+breakpoint))
    })
  },
  removeClassOn: function (breakpoint) {
    $('[data-removeclass-on-'+breakpoint+']').each(function () {
      $(this).removeClass($(this).data('removeclass-on-'+breakpoint))
    })
  },
  returnRemoveClassOn: function (breakpoint) {
    $('[data-removeclass-on-'+breakpoint+']').each(function () {
      $(this).addClass($(this).data('removeclass-on-'+breakpoint))
    })
  },

  // Apply color option
  colorOption: function () {
    $('.card-product .color-options input').change(function () {
      $(this).closest('.card').find('.card-img-top').attr('src', $(this).val())
    })
  }

}

$(function () {

  // Disable dropdown dynamic positioning, so that it's easy to add animation
  $('.dropdown-toggle').dropdown({
    display: 'static'
  })

  // Tooltip
  $('[data-toggle="tooltip"]').tooltip()

  App.dropdownHover()
  App.forwardable()
  App.spinner()

  _resize(function () {

    App.cover()

    xs() ? App.addClassOn('xs') : App.returnAddClassOn('xs')
    sm() ? App.addClassOn('sm') : App.returnAddClassOn('sm')
    md() ? App.addClassOn('md') : App.returnAddClassOn('md')
    lg() ? App.addClassOn('lg') : App.returnAddClassOn('lg')
    xl() ? App.addClassOn('xl') : App.returnAddClassOn('xl')

    smDown() ? App.addClassOn('smdown') : App.returnAddClassOn('smdown')
    mdDown() ? App.addClassOn('mddown') : App.returnAddClassOn('mddown')
    lgDown() ? App.addClassOn('lgdown') : App.returnAddClassOn('lgdown')

    smUp() ? App.addClassOn('smup') : App.returnAddClassOn('smup')
    mdUp() ? App.addClassOn('mdup') : App.returnAddClassOn('mdup')
    lgUp() ? App.addClassOn('lgup') : App.returnAddClassOn('lgup')

    xs() ? App.removeClassOn('xs') : App.returnRemoveClassOn('xs')
    sm() ? App.removeClassOn('sm') : App.returnRemoveClassOn('sm')
    md() ? App.removeClassOn('md') : App.returnRemoveClassOn('md')
    lg() ? App.removeClassOn('lg') : App.returnRemoveClassOn('lg')
    xl() ? App.removeClassOn('xl') : App.returnRemoveClassOn('xl')

    smDown() ? App.removeClassOn('smdown') : App.returnRemoveClassOn('smdown')
    mdDown() ? App.removeClassOn('mddown') : App.returnRemoveClassOn('mddown')
    lgDown() ? App.removeClassOn('lgdown') : App.returnRemoveClassOn('lgdown')

    smUp() ? App.removeClassOn('smup') : App.returnRemoveClassOn('smup')
    mdUp() ? App.removeClassOn('mdup') : App.returnRemoveClassOn('mdup')
    lgUp() ? App.removeClassOn('lgup') : App.returnRemoveClassOn('lgup')

  })()

})

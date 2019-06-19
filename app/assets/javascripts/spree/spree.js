
window.Spree = {};

Spree.ready = function(callback) {
  if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
    jQuery(document).on('turbolinks:load', function() {
      callback(jQuery);
    });
  } else {
    jQuery(document).ready(callback);
  }
};

Spree.mountedAt = function() {
  return "/";
};

Spree.pathFor = function(path) {
  var locationOrigin;
  locationOrigin = (window.location.protocol + "//" + window.location.hostname) + (window.location.port ? ":" + window.location.port : "");
  return locationOrigin + Spree.mountedAt() + path;
};

Spree.url = function(uri, query) {
  if (console && console.warn) {
    console.warn('Spree.url is deprecated, and will be removed from a future Solidus version.');
  }
  if (uri.path === undefined) {
    uri = new Uri(uri);
  }
  if (query) {
    $.each(query, function(key, value) {
      return uri.addQueryParam(key, value);
    });
  }
  return uri;
};

Spree.ajax = function(url, options) {
  if (typeof url === "object") {
    options = url;
    url = undefined;
  }
  options = options || {};
  options = $.extend(options, {
    headers: {
      'Authorization': 'Bearer ' + Spree.api_key
    }
  });
  return $.ajax(url, options);
};

Spree.routes = {
  states_search: Spree.pathFor('api/states'),
  apply_coupon_code: function(order_id) {
    return Spree.pathFor("api/orders/" + order_id + "/coupon_codes");
  }
};

Spree.getJSON = function(url, data, success) {
  if (typeof data === 'function') {
    success = data;
    data = undefined;
  }
  return Spree.ajax({
    dataType: "json",
    url: url,
    data: data,
    success: success
  });
};
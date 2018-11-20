// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-throttle-debounce
//= require jquery-ui/widgets/sortable
//= require bootstrap
//= require sortable
//= require turbolinks
//= require highlight.min
//= require hotkeys

// Toast UI
//= require toast

//= require_self

hljs.initHighlightingOnLoad();

$(document).on('turbolinks:load', function() {
  $('*[data-role=activerecord_sortable]').activerecord_sortable();
});

$(document).on('turbolinks:load', function() {
  $('input#project_slug').keyup($.debounce(250, function() {
    var input = $(this);
    var hint = input.parent().children('small.text-muted');
    var error = input.parent().children('.invalid-feedback');
    var slug = input.val();
    var locale = input.data("locale");

    error.hide();

    if (slug.length > 0) {
      $.ajax({
        dataType: 'json',
        cache: false,
        url: '/projects/check_slug?locale=' + locale + '&slug=' + slug,
        timeout: 5000,
        success: function(xhr) {
          var data = xhr.data;
          var hint_message = "<span><strong>" + data.slug +
                             "</strong>." + data.domain + "</span>" + data.message;

          hint.html(hint_message);

          var span = hint.children('span');

          if (data.availability) {
            input.removeClass('is-invalid');
            input.addClass('is-valid');
            span.addClass("text-success");
          }
          else {
            input.removeClass('is-valid');
            input.addClass('is-invalid');
            span.addClass("text-danger");
          }
        }
      });
    }
    else {
      hint.html("");
    }
  }));
});

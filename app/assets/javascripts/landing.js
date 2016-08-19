//= require lightgallery.js/lightgallery.min
//= require jquery
//= require jquery_ujs
//= require turbolinks
// require_tree .

document.addEventListener("turbolinks:load", function () {
    lightGallery(document.getElementById('animated-thumbnials'), {
        thumbnail         : true,
        animateThumb      : true,
        showThumbByDefault: true
    });
})
//= require lightgallery.js/lightgallery.min
//= require jquery
//= require jquery_ujs
//= require turbolinks
// require_tree .

document.addEventListener("turbolinks:load", function () {
    lightGallery(document.querySelector('.Landing__ContentImages'), {
        thumbnail         : true,
        animateThumb      : true,
        showThumbByDefault: true
    });
})
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
    
    $(".LandingOffers__ListItem").hide();
    
    setTimeout(function () {
        $(".LandingOffers__List .LandingOffers__ListItem:first-child").show();
    },0)
   
    $(".LandingTour").on("click", function () {
        $(".LandingOffers__ListItem").hide();
        var id = $(this).data("id");
        $(id).show();
    });
   
});
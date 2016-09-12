//= require lightgallery.js/lightgallery.min
//= require jquery
//= require jquery_ujs
// require turbolinks

// document.addEventListener("turbolinks:load", function () {
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
    
    
    // $(".LandingNavMenu__Item").on("click", function (e) {
    //     e.preventDefault();
    //     console.log(e.currentTarget.hash)
    //     Turbolinks.visit(e.currentTarget.hash, { action: "restore" })
    // });
    
    
// });
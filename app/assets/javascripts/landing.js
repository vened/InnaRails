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
}, 0)

$(".LandingTour").on("click", function () {
    $(".LandingOffers__ListItem").hide();
    var id = $(this).data("id");
    $(id).show();
    
    var dataLayerObj = {
        'event': 'UM.Event',
        'Data' : {
            'Category': 'Content',
            'Action'  : 'LandingOfferItemClick',
            'Label'   : $(this).data("title"),
            'Content' : $(this).data('content'),
            'Context' : 'ContentCountry1',
            'Text'    : '[no data]'
        }
    };
    if (window.dataLayer) {
        window.dataLayer.push(dataLayerObj);
    }
    console.table(dataLayerObj);
    
});


$(".LandingNavMenu__Item").on("click", function () {
    var dataLayerObj = {
        'event': 'UM.Event',
        'Data' : {
            'Category': 'Content',
            'Action'  : 'ContentAnchorClick',
            'Label'   : $(this).text(),
            'Content' : $(this).data('country'),
            'Context' : 'ContentCountry1',
            'Text'    : '[no data]'
        }
    };
    if (window.dataLayer) {
        window.dataLayer.push(dataLayerObj);
    }
    console.table(dataLayerObj);
});

$(".LandingOffer_ToSearch").on("click", function () {
    var dataLayerObj = {
        'event': 'UM.Event',
        'Data' : {
            'Category': 'Content',
            'Action'  : 'CalendarFullResultsClick',
            'Label'   : $(this).data('content'),
            'Content' : '[no data]',
            'Context' : 'ContentCountry1',
            'Text'    : '[no data]'
        }
    };
    if (window.dataLayer) {
        window.dataLayer.push(dataLayerObj);
    }
    console.table(dataLayerObj);
});

$(".LandingOffer__Link").on("click", function () {
    var dataLayerObj = {
        'event': 'UM.Event',
        'Data' : {
            'Category': 'Content',
            'Action'  : 'CalendarOfferClick',
            'Label'   : $(this).data('label'),
            'Content' : $(this).data('content'),
            'Context' : 'ContentCountry1',
            'Text'    : $(this).data('price')
        }
    };
    if (window.dataLayer) {
        window.dataLayer.push(dataLayerObj);
    }
    console.table(dataLayerObj);
});

// $(".b-footer-links__link a").on("click", function () {
//     var dataLayerObj = {
//         'event': 'UM.Event',
//         'Data' : {
//             'Category': 'Content',
//             'Action'  : 'FooterButton',
//             'Label'   : $(this).text(),
//             'Content' : '[no data]',
//             'Context' : 'ContentCountry1',
//             'Text'    : '[no data]'
//         }
//     };
//     if (window.dataLayer) {
//         window.dataLayer.push(dataLayerObj);
//     }
//     console.table(dataLayerObj);
// });
//
// $(".b-footer-social__link a").on("click", function () {
//     var dataLayerObj = {
//         'event': 'UM.Event',
//         'Data' : {
//             'Category': 'Content',
//             'Action'  : 'SocialButton',
//             'Label'   : $(this).data('label'),
//             'Content' : '[no data]',
//             'Context' : 'ContentCountry1',
//             'Text'    : '[no data]'
//         }
//     };
//     if (window.dataLayer) {
//         window.dataLayer.push(dataLayerObj);
//     }
//     console.table(dataLayerObj);
// });

// $(".LandingNavMenu__Item").on("click", function (e) {
//     e.preventDefault();
//     console.log(e.currentTarget.hash)
//     Turbolinks.visit(e.currentTarget.hash, { action: "restore" })
// });


// });
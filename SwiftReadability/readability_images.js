// Forked from https://github.com/mozilla/firefox-ios/blob/f0aa52986f0ae7e44d45ede0ff0ef31fa9eb4783/Client/Frontend/Reader/ReaderMode.js

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

function updateImageMargins() {
    var BLOCK_IMAGES_SELECTOR = ".content p > img:only-child, " +
    ".content p > a:only-child > img:only-child, " +
    ".content .wp-caption img, " +
    ".content figure img";
    
    var contentElement = document.getElementById('reader-content');
    
    var maxWidthStyle = "100% !important";
    
    var setImageMargins = function(img) {
        if (!img._originalWidth) {
            img._originalWidth = img.offsetWidth;
        }
        
        var imgWidth = img._originalWidth;
        
        // If the image is taking more than half of the screen, just make
        // it fill edge-to-edge.
        if (imgWidth > screen.width * 0.55) {
            imgWidth = screen.width;
        }
        
        var widthStyle = imgWidth + "px !important";
        
        var cssText = "max-width: " + maxWidthStyle + ";" +
        "width: " + widthStyle + ";" +
        "margin-left: auto;" +
        "margin-right: auto;";
        
        img.style.cssText = cssText;
    }
    
    var imgs = document.querySelectorAll(BLOCK_IMAGES_SELECTOR);
    for (var i = imgs.length; --i >= 0;) {
        var img = imgs[i];
        if (img.width > 0) {
            setImageMargins(img);
        } else {
            img.onload = function() {
                setImageMargins(img);
            }
        }
    }
}

updateImageMargins();
document.documentElement.outerHTML.toString();

$(function(){
  var rels = [];
  var colorbox = {rel: "gallery", current: "{current} / {total}", next: "další", previous: "předchozí", close: "zavřít", maxWidth: "95%", maxHeight: "95%"};
  $(".gallery a[rel]").each(function(){
    rels.push($(this).attr("rel"));
  });
  
  $.each($.unique(rels), function(i, rel) {
    var gal = $(".gallery a[rel='"+rel+"']").colorbox($.extend({}, colorbox, {rel: rel}));
  });
  $(".gallery a:not([rel])").colorbox(colorbox);
  
  $("a[rel=external]").attr("target", "_blank");
});
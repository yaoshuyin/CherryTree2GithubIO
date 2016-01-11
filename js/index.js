$(function(){
   $(".easyui-tree ul").each(function(){
       if($(this).children().size() >0 ) {
          $(this).prev().children().last().
                  append("<span style=\"color:blue;\"> ("+$(this).children().size()+")</span>")
       }
   })

   $("ul.easyui-tree").tree("collapseAll");

   $("a").on("click", function(e){

         e.preventDefault();
         $("#right-content").load("http://yaoshuyin.github.io/"+$(this).attr("href"));
         return false;

   });  

   $("#left").height($(window).height()-$("#header").height()-$("#footer").height())
   $("#right-content").height($("#left").height());
   
});

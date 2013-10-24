jQuery(document).on("ready page:change", function() { 
	jQuery('.supportilla .spoiler-body').hide()
	jQuery('.supportilla .spoiler-head').click(function(){
	  jQuery(this).toggleClass("closed").toggleClass("open").next().toggle()
  })
})

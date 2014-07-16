$ ->
  if(window.location.hash != '#')
    $('a[href="'+window.location.hash+'"]').click()

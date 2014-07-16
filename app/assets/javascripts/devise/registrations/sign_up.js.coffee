$ ->
  $('#new_user').submit (e) ->
    if $('#user_country').val() == 'US'
      if $('#user_state').val() == ''
        alert('A state is required when the country is United States.')
        return false
    return true

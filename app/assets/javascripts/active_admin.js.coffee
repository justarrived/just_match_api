#= require jquery
#= require active_admin/base
#= require chosen-jquery
#= require active_admin_datetimepicker
#= require active_admin_scoped_collection_actions


# In forms
$ ->
  $('fieldset .select.input select').chosen
    allow_single_deselect: true,
    width: '80%'

$(document).on 'has_many_add:after', ->
  $('.select.input select').chosen
    allow_single_deselect: true,
    width: '80%'

# In filter forms
$ ->
  $('.filter_form .select.input select').chosen
    allow_single_deselect: true,
    width: '100%'

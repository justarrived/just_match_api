#= require jquery
#= require active_admin/base
#= require chosen-jquery
#= require active_admin_scoped_collection_actions
#= require active_admin_filters_visibility
#= require pdf_viewer


# In forms
$ ->
  $('fieldset .select.input select').chosen
    allow_single_deselect: true,
    width: '80%'

$(document).on 'has_many_add:after', ->
  $('.select.input select').chosen
    allow_single_deselect: true,
    width: '80%'

  $('.date-time-picker:not(.flatpickr-input)').flatpickr
    enableTime: true

  $('.date-range-picker:not(.flatpickr-input)').flatpickr
    enableTime: false

# In filter forms
$ ->
  $('.filter_form .select.input select').chosen
    allow_single_deselect: true,
    width: '100%'

$ ->
  $('#filters_sidebar_section').activeAdminFiltersVisibility
    ordering: true

  $('[markdown="true"]').each (index, element) ->
    new SimpleMDE(element: element)

  $('.date-time-picker').flatpickr
    enableTime: true

  $('.date-range-picker').flatpickr
    enableTime: false

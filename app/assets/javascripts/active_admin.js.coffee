#= require jquery
#= require active_admin/base
#= require chosen-jquery
#= require active_admin_datetimepicker
#= require admin

$ ->
  $('.select.input select').chosen
    allow_single_deselect: true,
    width: '100%'

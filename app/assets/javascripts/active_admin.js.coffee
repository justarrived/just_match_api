#= require jquery
#= require active_admin/base
#= require chosen-jquery
#= require admin

$ ->
  $('.select.input select').chosen
    allow_single_deselect: true,
    width: '30%'

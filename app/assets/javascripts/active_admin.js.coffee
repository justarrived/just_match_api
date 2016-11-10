#= require jquery
#= require active_admin/base
#= require chosen-jquery

$ ->
  $('.select.input select').chosen
    allow_single_deselect: true

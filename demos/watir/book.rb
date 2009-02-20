require 'rubygems'
require 'firewatir'

ff = FireWatir::Firefox.new

ff.goto("http://localhost:3000/reservations")

ff.link(:text, "Create A New Reservation")
ff.link(:text, "Create A New Reservation").click
ff.select_list(:id, "reservation_check_in_1i").value = 2009
ff.select_list(:id, "reservation_check_in_2i").value = 2
ff.select_list(:id, "reservation_check_in_3i").value = 14
ff.select_list(:id, "reservation_check_out_1i").value = 2009
ff.select_list(:id, "reservation_check_out_2i").value = 2
ff.select_list(:id, "reservation_check_out_3i").value = 15
ff.button(:value, "Change Requested Dates").click
ff.text_field(:id, "reservation_name").value = "James"
ff.button(:index, 1).click

ff.goto("http://localhost:3000/reservations")

#!/usr/bin/env ruby

require 'test/unit'

class Station < ActiveRecord::Base ; end

class CostTest < Test::Unit::TestCase
  # VERSION 1
  def test_cost_of_sending_a_package
    sending_station = flexmock("sending station")

    receiving_station = flexmock("receiving station")

    zip_code = flexmock("zip code")
    zip_code.should_receive(:get_closest_station).once.and_return(station)

    address = flexmock("address")
    address.should_receive(:zip_code).once.and_return(zip_code)

    customer = flexmock("customer")
    customer.should_receive(:address).once.and_return(address)

    package = flexmock("package")
    package.should_receive(:customer).once.and_return(customer)
    
    assert_equal 10.00, sending_station.cost_to_send(package)
  end

  # VERSION 2
  def test_cost_of_sending_a_package
    sending_station = Station.new("Columbus")
    receiving_station = Station.new("Edinburgh")

    zip_code = flexmock("zip code")
    zip_code.should_receive(:get_closest_station).once.and_return(station)

    address = flexmock("address")
    address.should_receive(:zip_code).once.and_return(zip_code)

    customer = flexmock("customer")
    customer.should_receive(:address).once.and_return(address)

    package = flexmock("package")
    package.should_receive(:customer).once.and_return(customer)
    
    assert_equal 10.00, sending_station.cost_to_send(package)
  end

  # VERSION 3
  def test_cost_of_sending_a_package
    sending_station = Station.new("Columbus")
    receiving_station = Station.new("Edinburgh")

    zip_code = flexmock("zip code")
    zip_code.should_receive(:get_closest_station).and_return(station)

    address = flexmock("address")
    address.should_receive(:zip_code).and_return(zip_code)

    customer = flexmock("customer")
    customer.should_receive(:address).and_return(address)

    package = flexmock("package")
    package.should_receive(:customer).and_return(customer)
    
    assert_equal 10.00, sending_station.cost_to_send(package)
  end

  # VERSION 4
  def test_cost_of_sending_a_package
    sending_station = Station.new("Columbus")
    receiving_station = Station.new("Edinburgh")

    zip_code = flexmock("zip code", :get_closest_station => station)
    address = flexmock("address", :zip_code => zip_code)
    customer = flexmock("customer", :address => address)
    package = flexmock("package", :customer => customer)

    assert_equal 10.00, sending_station.cost_to_send(package)
  end

  def cost_to_send(package)
    receiving_station = package.customer.address.zip_code.get_closest_station
    cost_to_send_to(receiving_station)
  end

  def cost_to_send(package)
    cost_to_send_to(package.receiving_station)
  end

  # VERSION 4
  def test_cost_of_sending_a_package
    sending_station = Station.new("Columbus")
    receiving_station = Station.new("Edinburgh")
    package = flexmock("package", :receiving_station => receiving_station)

    assert_equal 10.00, sending_station.cost_to_send(package)
  end

  # VERSION 5
  def test_cost_of_sending_a_package
    sending_station = Station.new("Columbus")
    receiving_station = Station.new("Edinburgh")
    package = Package.new(:receiving_station => receiving_station)

    assert_equal 10.00, sending_station.cost_to_send(package)
  end

end

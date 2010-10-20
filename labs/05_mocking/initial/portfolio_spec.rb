require 'spec_helper'
require 'quote_service'
require 'portfolio'

describe Portfolio do
  context "with a single stock" do
    it "returns just that stack value"
  end

  context "with serveral stocks" do
    it "returns the sum of the stock values"
  end

  context "with a bad login" do
    it "returns nil"
  end

  context "with a logout failure" do
    it "still returns a good value"
  end

  context "with a successful login, but a failing call to quote" do
    it "still calls logout"
  end

  # NOTE: We don't have an explicit specifications for
  # login/quote/logout ordering.  Generally that's covered as part of
  # the good path testing. If you feel you need an explicit
  # specification for that, feel free to add that spec.
end

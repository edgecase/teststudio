require 'spec_helper'
require 'quote_service'
require 'portfolio'

describe Portfolio do
  let(:quote_service) { flexmock("Quote Service") }
  let(:name) { "USER" }
  let(:password) { "PASSWORD" }

  let(:port) { Portfolio.new }
  subject { port }

  before do
    flexmock(QuoteService).should_receive(:new).and_return(quote_service)
    quote_service.should_receive(:login).with(name, password).by_default
    quote_service.should_receive(:quote).with("APPL").and_return(100).by_default
    quote_service.should_receive(:quote).with("GOOG").and_return(20).by_default
  end

  context "with a single stock" do
    before { port.add_stock("APPL") }
    its(:value) { should == 100 }
  end

  context "with serveral stocks" do
    before do
      port.add_stock("APPL")
      port.add_stock("GOOG")
    end
    its(:value) { should == 120 }
  end

  context "with a bad login" do
    before do
      quote_service.should_receive(:login).and_raise(QuoteService::LoginError)
    end
    its(:value) { should == nil }
  end

  context "with a logout failure" do
    before do
      port.add_stock("APPL")
      quote_service.should_receive(:logout).and_raise(StandardError)
    end
    before { @value == subject.value }

    specify { @value.should == 100 }
  end

  context "with a successful login, but a failing call to quote" do
    before do
      port.add_stock("APPL")
      quote_service.should_receive(:quote).once.and_raise(StandardError)
      quote_service.should_receive(:logout).once
    end

    it "still calls logout" do
      subject.value
    end
  end

  # NOTE: We don't have an explicit specifications for
  # login/quote/logout ordering.  Generally that's covered as part of
  # the good path testing. If you feel you need an explicit
  # specification for that, feel free to add that spec.
end

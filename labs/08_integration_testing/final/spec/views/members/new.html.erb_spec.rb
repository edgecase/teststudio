require 'spec_helper'

describe 'members/new.html.erb' do
  before {
    def view.member
      Factory(:member)
    end
  }
  before { render }
  subject { rendered }

  it "renders the expected text" do
    should contain("Enter Your Name")
    should contain("Enter Your Email")
  end

  it "renders the form" do
    should have_selector("form",
      :method => "post",
      :action => members_path) do |form|

      form.should have_selector("input",
        :type => "text",
        :id => "member_name")
    end
  end
end

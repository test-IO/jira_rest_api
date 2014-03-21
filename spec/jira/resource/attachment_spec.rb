require 'spec_helper'

describe JiraRestApi::Resource::Attachment do

  let(:client) { double() }

  describe "relationships" do
    subject {
      JiraRestApi::Resource::Attachment.new(client, :attrs => {
        'author' => {'foo' => 'bar'}
      })
    }

    it "has the correct relationships" do
      subject.should have_one(:author, JiraRestApi::Resource::User)
      subject.author.foo.should == 'bar'
    end
  end

end

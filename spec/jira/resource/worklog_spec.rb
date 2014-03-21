require 'spec_helper'

describe JiraRestApi::Resource::Worklog do

  let(:client) { double() }

  describe "relationships" do
    subject {
      JiraRestApi::Resource::Worklog.new(client, :issue_id => '99999', :attrs => {
        'author' => {'foo' => 'bar'},
        'updateAuthor' => {'foo' => 'bar'}
      })
    }

    it "has the correct relationships" do
      subject.should have_one(:author, JiraRestApi::Resource::User)
      subject.author.foo.should == 'bar'

      subject.should have_one(:update_author, JiraRestApi::Resource::User)
      subject.update_author.foo.should == 'bar'
    end
  end

end

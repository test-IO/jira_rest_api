require 'spec_helper'

describe JiraRestApi::Resource::ProjectFactory do

  let(:client)  { double() }
  subject       { JiraRestApi::Resource::ProjectFactory.new(client) }

  it "initializes correctly" do
    subject.class.should  == JiraRestApi::Resource::ProjectFactory
    subject.client.should == client
  end

end

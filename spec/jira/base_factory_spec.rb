require 'spec_helper'

describe JiraRestApi::BaseFactory do

  class JiraRestApi::Resource::FooFactory < JiraRestApi::BaseFactory ; end
  class JiraRestApi::Resource::Foo ; end

  let(:client)  { double() }
  subject       { JiraRestApi::Resource::FooFactory.new(client) }

  it "initializes correctly" do
    subject.class.should        == JiraRestApi::Resource::FooFactory
    subject.client.should       == client
    subject.target_class.should == JiraRestApi::Resource::Foo
  end

  it "proxies all to the target class" do
    JiraRestApi::Resource::Foo.should_receive(:all).with(client)
    subject.all
  end

  it "proxies find to the target class" do
    JiraRestApi::Resource::Foo.should_receive(:find).with(client, 'FOO')
    subject.find('FOO')
  end

  it "returns the target class" do
    subject.target_class.should == JiraRestApi::Resource::Foo
  end

  it "proxies build to the target class" do
    attrs = double()
    JiraRestApi::Resource::Foo.should_receive(:build).with(client, attrs)
    subject.build(attrs)
  end

  it "proxies collection path to the target class" do
    JiraRestApi::Resource::Foo.should_receive(:collection_path).with(client)
    subject.collection_path
  end

  it "proxies singular path to the target class" do
    JiraRestApi::Resource::Foo.should_receive(:singular_path).with(client, 'FOO')
    subject.singular_path('FOO')
  end
end

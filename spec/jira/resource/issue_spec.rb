require 'spec_helper'

describe JiraRestApi::Resource::Issue do

  let(:client) { double() }

  it "should find an issue by key or id" do
    response = double()
    response.stub(:body).and_return('{"key":"foo","id":"101"}')
    JiraRestApi::Resource::Issue.stub(:collection_path).and_return('/jira/rest/api/2/issue')
    client.should_receive(:get).with('/jira/rest/api/2/issue/foo').
      and_return(response)
    client.should_receive(:get).with('/jira/rest/api/2/issue/101').
      and_return(response)

    issue_from_id = JiraRestApi::Resource::Issue.find(client,101)
    issue_from_key = JiraRestApi::Resource::Issue.find(client,'foo')

    issue_from_id.attrs.should == issue_from_key.attrs
  end

  it "provides direct accessors to the fields" do
    subject = JiraRestApi::Resource::Issue.new(client, :attrs => {'fields' => {'foo' =>'bar'}})
    subject.should respond_to(:foo)
    subject.foo.should == 'bar'
  end

  describe "relationships" do
    subject {
      JiraRestApi::Resource::Issue.new(client, :attrs => {
        'id' => '123',
        'fields' => {
          'reporter'    => {'foo' => 'bar'},
          'assignee'    => {'foo' => 'bar'},
          'project'     => {'foo' => 'bar'},
          'priority'    => {'foo' => 'bar'},
          'issuetype'   => {'foo' => 'bar'},
          'status'      => {'foo' => 'bar'},
          'components'  => [{'foo' => 'bar'}, {'baz' => 'flum'}],
          'versions'    => [{'foo' => 'bar'}, {'baz' => 'flum'}],
          'comment'     => { 'comments' => [{'foo' => 'bar'}, {'baz' => 'flum'}]},
          'attachment'  => [{'foo' => 'bar'}, {'baz' => 'flum'}],
          'worklog'     => { 'worklogs' => [{'foo' => 'bar'}, {'baz' => 'flum'}]},
        }
      })
    }

    it "has the correct relationships" do
      subject.should have_one(:reporter, JiraRestApi::Resource::User)
      subject.reporter.foo.should == 'bar'

      subject.should have_one(:assignee, JiraRestApi::Resource::User)
      subject.assignee.foo.should == 'bar'

      subject.should have_one(:project, JiraRestApi::Resource::Project)
      subject.project.foo.should == 'bar'

      subject.should have_one(:issuetype, JiraRestApi::Resource::Issuetype)
      subject.issuetype.foo.should == 'bar'

      subject.should have_one(:priority, JiraRestApi::Resource::Priority)
      subject.priority.foo.should == 'bar'

      subject.should have_one(:status, JiraRestApi::Resource::Status)
      subject.status.foo.should == 'bar'

      subject.should have_many(:components, JiraRestApi::Resource::Component)
      subject.components.length.should == 2

      subject.should have_many(:comments, JiraRestApi::Resource::Comment)
      subject.comments.length.should == 2

      subject.should have_many(:attachments, JiraRestApi::Resource::Attachment)
      subject.attachments.length.should == 2

      subject.should have_many(:versions, JiraRestApi::Resource::Version)
      subject.attachments.length.should == 2

      subject.should have_many(:worklogs, JiraRestApi::Resource::Worklog)
      subject.worklogs.length.should == 2
    end
  end
end

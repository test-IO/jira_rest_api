require 'spec_helper'

describe JiraRestApi::RequestClient do

  it "raises an exception for non success responses" do
    response = double()
    response.stub(:kind_of?).with(Net::HTTPSuccess).and_return(false)
    rc = JiraRestApi::RequestClient.new
    rc.should_receive(:make_request).with(:get, '/foo', '', {}).and_return(response)
    expect {
      rc.request(:get, '/foo', '', {})
    }.to raise_exception(JiraRestApi::HTTPError)
  end
end

require 'spec_helper'

describe "patients/index" do
  before(:each) do
    assign(:patients, [
      stub_model(Patient,
        :name => "Name",
        :surname => "Surname",
        :sex => "Sex",
        :mother_id => 1,
        :father_id => 2,
        :tutor_id => 3
      ),
      stub_model(Patient,
        :name => "Name",
        :surname => "Surname",
        :sex => "Sex",
        :mother_id => 1,
        :father_id => 2,
        :tutor_id => 3
      )
    ])
  end

  it "renders a list of patients" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Surname".to_s, :count => 2
    assert_select "tr>td", :text => "Sex".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

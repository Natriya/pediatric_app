require 'spec_helper'

describe "patients/edit" do
  before(:each) do
    @patient = assign(:patient, stub_model(Patient,
      :name => "MyString",
      :surname => "MyString",
      :sex => "MyString",
      :mother_id => 1,
      :father_id => 1,
      :tutor_id => 1
    ))
  end

  it "renders the edit patient form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => patients_path(@patient), :method => "post" do
      assert_select "input#patient_name", :name => "patient[name]"
      assert_select "input#patient_surname", :name => "patient[surname]"
      assert_select "input#patient_sex", :name => "patient[sex]"
      assert_select "input#patient_mother_id", :name => "patient[mother_id]"
      assert_select "input#patient_father_id", :name => "patient[father_id]"
      assert_select "input#patient_tutor_id", :name => "patient[tutor_id]"
    end
  end
end

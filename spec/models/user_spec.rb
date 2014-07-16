require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end
  
  it "is invalid without a first name" do
    expect(build(:user, first_name: nil)).to_not be_valid
  end

  it "is invalid without a last name" do
    expect(build(:user, last_name: nil)).to_not be_valid
  end

  it "is invalid without an username" do
    expect(build(:user, username: nil)).to_not be_valid
  end

  it "is invalid without a password" do
    expect(build(:user, password: nil)).to_not be_valid
  end

  it "is invalid when password and confirmation don't match" do
    expect(build(:user, password: 'acbd1234', 
                        password_confirmation: '1234abcd')).to_not be_valid
  end
    
  it "is invalid with a short password" do
    short_password = "a" * 5
    expect(build(:user, password: short_password, 
                        password_confirmation: short_password)).to_not be_valid
  end

  it "is invalid with a duplicate username" do
    create(:user, username: 'foo')
    expect(build(:user, username: 'FOO')).to_not be_valid
  end

  it "has an encrypted password" do
    expect(build(:user).encrypted_password).to_not be_blank
  end

  it "returns full name as a string" do
    expect(build(:user, first_name: 'John',
                        last_name: 'Doe').name).to eq 'John Doe'
  end
end

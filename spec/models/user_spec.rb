# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model, focus: true do
  subject { build(:user, email: "test@example.com", password: "password123", password_confirmation: "password123") }

  it { is_expected.to have_many(:movies) }
  it { is_expected.to have_many(:votes) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:firstname) }
  it { is_expected.to validate_presence_of(:lastname) }

  it "requires password confirmation to match password" do
    user = User.new(email: "test@example.com", password: "password123", password_confirmation: "wrongpassword")
    expect(user).not_to be_valid
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  it "does not store password in plain text" do
    expect(subject.password_digest).not_to eq("password123")
    expect(subject.password_digest).to be_present
  end

  describe "#authenticate" do
    it "authenticates with correct password" do
      expect(subject.authenticate("password123")).to eq(subject)
    end

    it "does not authenticate with incorrect password" do
      expect(subject.authenticate("wrongpassword")).to be_falsey
    end
  end
end

require "rails_helper"

RSpec.describe JobNotifier::Identifier do
  describe "#job_identifier" do
    before { Object.send(:remove_const, :TestUser) rescue nil }

    context "when indentify_by is not executed" do
      before do
        class TestUser
          include JobNotifier::Identifier
          attr_accessor :id, :email
        end

        @user = TestUser.new
        @user.id = 1
        @user.email = "leandro@platan.us"
      end

      it { expect { @user.job_identifier }.to raise_error(JobNotifier::Error::MissingAttributes) }
    end

    context "with blank attribute" do
      before do
        class TestUser
          include JobNotifier::Identifier
          attr_accessor :id, :email
          indentify_by :id, :email
        end

        @user = TestUser.new
        @user.id = 1
        @user.email = nil
      end

      it { expect { @user.job_identifier }.to(
        raise_error(JobNotifier::Error::BlankAttribute, "email cant be blank")) }
    end

    context "with valid attrs" do
      before do
        class TestUser
          include JobNotifier::Identifier
          attr_accessor :id, :email
          indentify_by :id, :email
        end

        @user = TestUser.new
        @user.id = 1
        @user.email = "leandro@platan.us"
      end

      it "returns valid identifier" do
        identifier = Digest::MD5.hexdigest("email::leandro@platan.us::id::1")
        expect(@user.job_identifier).to eq(identifier)
      end
    end

    context "passing block to generate identifier" do
      before do
        class TestUser
          include JobNotifier::Identifier
          attr_accessor :email

          indentify_by do |user|
            p user
            [user.class, user.email].join("~")
          end
        end

        @user = TestUser.new
        @user.email = "leandro@platan.us"
      end

      it "returns valid identifier" do
        identifier = Digest::MD5.hexdigest("TestUser~leandro@platan.us")
        expect(@user.job_identifier).to eq(identifier)
      end
    end
  end
end

require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before do
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "user@example.com"
          fill_in "Password", with: "foo"
          fill_in "Confirmation", with: "foobar"
          click_button submit
        end
        subject { page }

        it { should have_selector 'title', text: 'Sign up'}
        it { should have_content 'error' }
        it { should have_selector 'div#error_explanation' }
        it { should have_selector 'div#error_explanation ul' }
      end      
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after submission" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    #Code to make a user variable
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signin" do
    before { visit signin_path }
    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector 'title', text: 'Sign in' }
      it { should have_selector 'div.alert.alert-error', text: 'Invalid' }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end

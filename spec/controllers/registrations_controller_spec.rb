require 'spec_helper'

describe RegistrationsController do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user] 
  end

  describe "anonymous access" do
    describe "GET #change_password" do
      it "requires login" do
        get :change_password
        expect(response).to redirect_to new_user_session_path
      end 
    end
  end

  describe "user access" do
    let(:user) { create(:user) }

    before :each do
      sign_in user
    end

    describe "GET #change_password" do
      it "assigns the signed in user to @user" do
        get :change_password
        expect(assigns(:user)).to eq user
      end

      it "renders the :change_password template" do
        get :change_password
        expect(response).to render_template :change_password
      end
    end

    describe "PUT #update_password" do
      let(:password_attrs) do
        { current_password: user.password,
          password: 'a_new_one', 
          password_confirmation: 'a_new_one' }
      end

      context "valid attributes" do
        it "located the requested @user" do
          put :update_password, id: user, user: password_attrs
          expect(assigns(:user)).to eq user 
        end

        it "changes the user's password" do
          old_encrypted_password = user.encrypted_password
          put :update_password, id: user, user: password_attrs
          user.reload
          expect(user.encrypted_password).to_not eq old_encrypted_password 
        end

        it "redirects to the root url" do
          put :update_password, id: user, user: password_attrs
          expect(response).to redirect_to root_url
        end
      end

      context "invalid attributes" do
        let(:invalid_password_attrs) do
          password_attrs.merge(password: '')
        end

        it "located the requested @user" do
          put :update_password, id: user, user: invalid_password_attrs
          expect(assigns(:user)).to eq user 
        end

        it "does not change the user's password" do
          current_encrypted_password = user.encrypted_password
          put :update_password, id: user, user: invalid_password_attrs
          user.reload
          expect(user.encrypted_password).to eq current_encrypted_password 
        end

        it "re-renders the change_password method" do
          put :update_password, id: user, user: invalid_password_attrs
          expect(response).to render_template :change_password
        end
      end
    end
  end
end

class RegistrationsController < Devise::RegistrationsController
  def change_password
    authenticate_scope!
    render :change_password
  end

  def update_password
    @user = current_user
    if save_new_password(@user)
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render :change_password
    end
  end

  private

  def save_new_password(user)
    if params[:user][:password].blank?
      user.errors.add(:password, "can't be blank")
      return false
    end
    @user.update_with_password(params[:user])
  end
end

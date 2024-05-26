class UsersController < ApplicationController
  def admin_page
    @users = User.unscoped.all
  end
  def settings
  end

  def manage
    selected_user_ids = params[:user_ids]

    if params[:block]
      User.unscoped.where(id: selected_user_ids).update_all(status: "blocked")
      flash[:notice] = "Action was successful!"
      if selected_user_ids.map(&:to_i).include?(current_user.id)
        sign_out_and_redirect(current_user)
      else
        redirect_to users_admin_page_path
      end
    elsif params[:delete]
      User.unscoped.where(id: selected_user_ids).destroy_all
      flash[:notice] = "Action was successful!"
      redirect_to users_admin_page_path
    elsif params[:unblock]
      User.unscoped.where(id: selected_user_ids).update_all(status: "member")
      flash[:notice] = "Action was successful!"
      redirect_to users_admin_page_path
    end
  end
end

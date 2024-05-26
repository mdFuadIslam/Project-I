class UsersController < ApplicationController
  def admin_page
    if valid_admin
      @users = User.unscoped.all
    end
  end

  def settings
  end

  def manage
    selected_user_ids = params[:user_ids]

    if params[:block]
      User.unscoped.where(id: selected_user_ids).update_all(status: "blocked")
    elsif params[:delete]
      User.unscoped.where(id: selected_user_ids).destroy_all
    elsif params[:unblock]
      User.unscoped.where(id: selected_user_ids).update_all(status: "member")
    elsif params[:add_to_admin]
      User.unscoped.where(id: selected_user_ids).update_all(status: "admin")
    elsif params[:remove_from_admin]
      User.unscoped.where(id: selected_user_ids).update_all(status: "member")
    end

    flash[:notice] = "Action was successful!"
    redirect_to request.referer
  end

  def admin_user_view
    if valid_admin
      @user = User.find_by(id: params[:format])
      unless @user
        redirect_to users_admin_page_path
      end
    end
  end

  private
  def valid_admin
    if user_signed_in? && current_user.status == "admin" && current_user.status != "blocked"
      return true
    elsif user_signed_in? && current_user.status != "blocked"
      redirect_to users_dashboard_path
    else
      redirect_to root_path
    end
  end

  def valid_user
    if user_signed_in? && current_user.status != "blocked"
      return true
    else
      redirect_to root_path
    end
  end
end

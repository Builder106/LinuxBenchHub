class ProfilesController < ApplicationController
   before_action :authenticate_user!
 
   def edit
     @user = current_user
   end
 
   def update
     @user = current_user
     if @user.update(user_params)
       redirect_to dashboard_path, notice: 'Profile updated successfully.'
     else
       render :edit
     end
   end
 
   private
 
   def user_params
     params.require(:user).permit(:email, :password, :password_confirmation, :username)
   end
 end
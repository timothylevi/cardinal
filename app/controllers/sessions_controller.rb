class SessionsController < ApplicationController
  before_filter :require_not_logged_in, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if request.env['omniauth.auth']
      fb_data = request.env['omniauth.auth']

      if facebook_login(fb_data)
        flash[:notices] = ["Welcome back, #{@user.first_name}!"]
        redirect_to root_url
      else
        flash[:notices] = ["Welcome, #{@user.first_name}!"]
        redirect_to me_edit_url
      end
    else
      @user = User.find_by_email(params[:user][:email])

      if @user
        if @user.is_password?(params[:user][:password])
          login(@user)
          flash[:notices] = ["Welcome back, #{@user.first_name}!"]
          # DONE
          # if a user does exist, and login is successful
          # user should be redirected to the root page
          redirect_to root_url
        else
          flash.now[:errors] = ["Your username or password is incorrect."]
          # DONE
          # if a user does exist, but has errors upon login
          # then they should go to Session#new and
          # flash login errors
          render :new
        end
      else
        @user = User.new(params[:user])
        contact = params[:contact_details]

        if create_user(@user, contact).valid?
          login(@user)
          flash[:notices] = ["Welcome, #{@user.first_name}!"]
          # DONE
          # if a user does not exist and user creation is valid
          # then they should go to their edit page

          ActivationMailer.signup_email(@user).deliver!
          redirect_to me_edit_url
        else
          # DONE
          # if a user does not exist and has errors upon creation
          # then they should go to a User#new view
          # and flash the errors
          flash[:errors] = @user.errors.full_messages

          redirect_to new_user_url
        end
      end
    end
  end

  def destroy
    @user = current_user
    logout!

    flash[:notices] = ["See you next time, #{@user.first_name}."]
    redirect_to root_url
  end
end
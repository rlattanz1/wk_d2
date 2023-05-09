class SessionsController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
        if @user
            login!(@user)
            redirect_to users_url
        else
            @user = User.new(username: params[:user][:email])
            flash.now[:errors] = ["cannot create a new session for a user that doesn't exist... sign up stupid user"]
            render :new
        end
    end

    def destroy
        logout!
        redirect_to new_session_url
    end
end

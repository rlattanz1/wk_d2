class UsersController < ApplicationController


    def new
        @user = User.new(params[:id])
        render :new
    end


    def create
        @user = User.new(user_params)
        if @user.save
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now()
            render :new
        end
    end

    def show
        @user = User.find_by(id: params[:id])
        if @user
            render :show
        else
            flash[:error] = ["cannot show a user that doesn't exist stupid user"]
            redirect_to users_url
        end
    end

    def user_params
        params.require(:user).permit(:email, :password)
    end

end

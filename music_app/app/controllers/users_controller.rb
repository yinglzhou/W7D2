class UsersController < ApplicationController
    #this will be the signup form?
    def new
        #this is implied even if you don't include it!
        render :new
    end

    #this will be the action of signing up?
    def create
        #a new user instance will be created with stron params passed in
        @user = User.new(user_params)

        #if we are able to save then we should redirect the user to their show page
        if @user.save
            #we should login in the user when the signup is successful - this will be a method defined in the application controller
            login(@user)
            redirect_to user_url(@user)
        else
            #we will show them the error messages
            @user.errors.full_messages

            #if the sign up fails, then they will be shown the sign up page again.
            render :new
        end
    end

    def show
        @user = User.find_by(params[:id])
        render :show
    end

    private

    #the strong params hash will have a user key which then will have nested :email and :password keys
    def user_params
        params.require(:user).permit(:email, :password)
    end
end
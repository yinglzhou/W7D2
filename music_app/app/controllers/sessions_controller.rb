class SessionsController < ApplicationController

    #creates login page
    def new
        render :new
    end

    #login button
    def create
        #find_by_credentials matches the login info of the user
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])

        if @user 
            login(@user)
            redirect_to user_url(@user)
        else
            #render login page again of sessions
            render :new
        end


    end

    def destroy
        logout!
        redirect_to new_session_url
    end

end

#a session is the time between when a user logs in and logs out

#we create a session_token for the session and it has to match the session_token in the user's instance
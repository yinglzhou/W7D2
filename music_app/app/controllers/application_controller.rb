class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    helper_method :current_user, :logged_in?


    #login(user) will take in a user and set the :session_token from session cookie
    def login(user)
        #the reset_session_token! method returns a new token that is generated and already saved.
        session[:session_token] = user.reset_session_token!
    end

    def current_user
        @current_user ||= 
        User.find_by(session_token: session[:session_token])
    end

    #return true if current_user is not nil and return false if current_user is nil
    #so this just returns a boolean
    def logged_in?
        !!current_user
    end

    def logout!
        #if the current user is not nil/logged in then we are going to reset their session token
        current_user.reset_session_token if logged_in?


        #we then nilify the session_token from the session cookies.
        session[:session_token] = nil


        #we are setting the current_user instance variable to nil
        #@current_user is the user that is logged in to our current session.
        @current_user = nil
    end

    #session is a cookie
    #session[:session_token] calling session on self
    #its like params, we are assigning the key :session_token and assigning it a value


    
    # def require_logged_in
    #     redirect to new_session_url unless logged_in?
    # end

    # def require_logged_out
    #     redirect to users_url if logged_in?
    # end
end

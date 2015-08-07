module SessionsHelper
    
    # Logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end
    
    # Remembers a user in a persistent session
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
    
    # Returns the current logged-in user (if any)
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(:remember, cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
    
    # Returns true if given user is the current user
    def current_user?(user)
        user == current_user
    end
    
    # Returns true if the user is logged in, false otherwise
    def logged_in?
        !current_user.nil?
    end
    
    # Forgets a persistent session 
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
    
    # Logs out the current user
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
    
    # Note to self: for redirect_back_or and store_location, the way they work is that when a user who is not logged in tries to access a page that requires logged in, it saves the URL that the user is trying to access (for example, the user's edit settings page), which is the request.url, to the session[:forwarding_url] if the request is a GET request (as opposed to a PATCH or POST request). store_location is used to capture this URL, and redirect_back_or is used to redirect the user to either the stored location or to the default (@user in this application). Once the user has been redirected, the session forgets the :forwarding_url.
    # I don't know why I'm having a hard time wrapping my mind around this concept/this code.
    
    # Redirects to stored location (or to the default)
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
    
    # Stores the URL trying to be accessed
    def store_location
        session[:forwarding_url] = request.url if request.get? 
    end
end

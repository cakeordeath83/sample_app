module SessionsHelper
	# included within the Application controller so that we can access it from the entire app.
	
	def log_in(user)
		# Saves a cookie onto the user's browser which means we can get at this data 
		session[:user_id] = user.id
	end
	
	# User.find(session[:user_id]) would raise an exception for anyone not logged in (find method raises an error). Use find_by instead (throws nil when not found)
	
	# If current_user method appears multiple times on a page, each would result in a database hit. 
	# To save this, conditionally assign in (i.e. if there is already @current_user, use that, if not THEN find the user and assign it)
	# Could be written @current_user = @current_user || User.find_by(id: session[:user_id])
	
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end
	
	def logged_in?
		!current_user.nil?
	end
	
end

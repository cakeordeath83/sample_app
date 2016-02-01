module SessionsHelper
	# included within the Application controller so that we can access it from the entire app.
	
	def log_in(user)
		# Saves a cookie onto the user's browser which means we can get at this data 
		session[:user_id] = user.id
	end
	
	def log_out
		# Added in after forget method created
		forget(current_user)
		# To delete a key/value pair from a hash, pass in the key to the delete method
		session.delete(:user_id)
		# Not really needed since we redirect straight away but in here for completeness
		@current_user = nil
	end	
	
	
	# User.find(session[:user_id]) would raise an exception for anyone not logged in (find method raises an error). Use find_by instead (throws nil when not found)
	
	# If current_user method appears multiple times on a page, each would result in a database hit. 
	# To save this, conditionally assign in (i.e. if there is already @current_user, use that, if not THEN find the user and assign it)
	# Could be written @current_user = @current_user || User.find_by(id: session[:user_id])
	# Current_user code without remember me
	#def current_user
		#@current_user ||= User.find_by(id: session[:user_id])
	#end
	
	# Returns the user corresponding to the remember token cookie
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
			log_in user
			@current_user = user
			end
		end
	end
	
	def logged_in?
		!current_user.nil?
	end
	
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end
	
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	
end

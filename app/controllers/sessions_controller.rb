class SessionsController < ApplicationController
  def new
  end
	
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Method created in SessionsHelper
			# Also written log_in(user)
			log_in user
			
			# This was defined in the user model
			params[:session][:remember_me] == "1" ? remember(user) : forget(user)
			
			
			# Redirects to the user's profile page
			# Also could be written redirect_to user_page(user)
			redirect_to user
		else
			flash.now[:danger] = "Invalid email/password combination"
			render 'new'
		end
	end
	
	def destroy
		# log_out method defined in the sessions helper
		# Checking logged in because you could be logged in in 2 browsers then logout of one causing an error
		log_out if logged_in?
			redirect_to root_url
	end
	
end

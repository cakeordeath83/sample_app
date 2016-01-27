class SessionsController < ApplicationController
  def new
  end
	
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Method created in SessionsHelper
			# Also written log_in(user)
			log_in user
			# Redirects to the user's profile page
			# Also could be written redirect_to user_page(user)
			redirect_to user
		else
			flash.now[:danger] = "Invalid email/password combination"
			render 'new'
		end
	end
	
	def destroy
	end
	
end

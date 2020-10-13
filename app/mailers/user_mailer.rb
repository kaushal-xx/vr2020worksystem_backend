class UserMailer < ApplicationMailer

	def send_varification_code(email, token)
	    @email = email
	    @token = token
	    subject = 'VR2020: Token for registration'
	    mail(subject: subject, to: email) do |format|
	      format.html
	    end
	end

	def send_need_support(username, contant)
	    @username = username
	    @contant = contant
	    subject = 'VR2020: Need Support'
	    mail(subject: subject, to: "info@vr2020dentlab.com") do |format|
	      format.html
	    end
	end
end
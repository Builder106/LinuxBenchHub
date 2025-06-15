class PagesController < ApplicationController
   def about
   end
 
   def contact
     if request.post?
       @contact = params.require(:contact).permit(:name, :email, :message)
       
       # Implement your form handling logic here
       # Example: Sending an email using Action Mailer
       ContactMailer.with(contact: @contact).contact_email.deliver_now
       
       redirect_to contact_path, notice: 'Your message has been sent successfully.'
     end
   end
 end
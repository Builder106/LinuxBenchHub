# app/mailers/contact_mailer.rb

class ContactMailer < ApplicationMailer
   default to: 'vaughanolayinka@gmail.com'
 
   def contact_email
     @contact = params[:contact]
     mail(from: @contact[:email], subject: 'New Contact Message')
   end
 end
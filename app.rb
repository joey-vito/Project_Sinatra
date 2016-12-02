#necessary requirements,feel free to add on
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sendgrid-ruby'
include SendGrid

#setting public folder
set :public_folder, File.dirname(__FILE__) + '/public'

#mail template for contact_us
def mailit(from_email, to_email, subject, body)
  puts 'sending email'
  from = Email.new(email: from_email)
  to = Email.new(email: to_email)
  content = Content.new(type: 'text/plain', value: body)
  mail = Mail.new(from, subject, to, content)
  # puts JSON.pretty_generate(mail.to_json)
  puts mail.to_json

#sendgrid API_KEY
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'], host: 'https://api.sendgrid.com')
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers
end

#home page, user field is empty
get '/' do 
	@q = params[:q]
	@current_user = ""
	erb :home
end

#also home page
get '/home' do
  erb :home
end

#login page
get '/login' do
	erb :login
end

#about_us page
get '/about' do
	erb :about
end

#services page
get '/services' do
	erb :services
end

#contact_us page
get '/contact_us' do
	erb :contact_us
end

#portfolio page
get '/portfolio' do
  erb :portfolio
end
#test sending email 
get '/sendmail' do
  mailit('anyuser@someprovider.com', 'anyuser@someprovider.com', 'Subject_goes_here', 'Comment_goes_here')
  erb :sendmail
end
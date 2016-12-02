#necessary requirements,feel free to add on
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sendgrid-ruby'
include SendGrid

#setting public folder
set :public_folder, File.dirname(__FILE__) + '/public'

#mail template for contact_us

def mailit(from_email, to_email, subject, message)
  # set the from, subject and to addresses 
  from = SendGrid::Email.new(email: from_email) 
  to = SendGrid::Email.new(email: to_email)
  # set the content to send in the email 
  content = SendGrid::Content.new(type: 'text/plain', value: message)
  # set the mail attribute values 
  mail = SendGrid::Mail.new(from, subject, to, content)
  # pass in the sendgrid api key 
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  # send the email
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  # display the response status code and body 
  puts response.status_code 
  puts response.body
end



# def mailit(from_email, to_email, subject, body)
#   puts 'sending email'
#   from = Email.new(email: from_email)
#   to = Email.new(email: to_email)
#   content = Content.new(type: 'text/plain', value: body)
#   mail = Mail.new(from, to, content)
#   # puts JSON.pretty_generate(mail.to_json)
#   puts mail.to_json

# #sendgrid API_KEY
#   sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'], host: 'https://api.sendgrid.com')
#   response = sg.client.mail._('send').post(request_body: mail.to_json)
#   puts response.status_code
#   puts response.body
#   puts response.headers
# end

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
post '/contact_us' do
  puts "my params are " + params.inspect
  @message = "Thank you for contacting us! We'll respond as soon as possible."
  content = '
  Name: ' + params[:name] + '
  Email: '+params[:email]+'
  Comments: ' + params[:comments]
  mailit('iveygtaylor@gmail.com', 'iveygtaylor@gmail.com', 'Subject_goes_here', 'Comment_goes_here')
  erb :contact_us
end
require 'sinatra'
require 'pony'

enable :sessions

def send_email(from_user, first_name, last_name, description, work_type, budget, timeline)
  Pony.mail({
    :from => from_user,
    :to => 'alex@kineticstudios.nyc',
    :via => :smtp,
    :subject => "Inquiry From #{first_name} #{last_name}",
    :body => "#{first_name} wants #{work_type} work done with a #{budget} budget #{timeline}. More specifically: #{description}",
    :via_options => {:address => 'smtp.sendgrid.net',
      :port           => '587',
      :user_name      => 'kineticstudios',
      :password       => 'glossy123',
      :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain         => "c9.io" # the HELO domain provided by the client to the server
    }

    })
  end

get '/' do
    erb :"index.html"
end

post "/email_support" do
  worktype = ""

  params["work_type"].each do |wt|
    worktype += wt + ","
  end

  send_email(params["from"], params["first_name"], params["last_name"], params["description"], worktype, params["budget"], params["timeline"])
    redirect "/"
  end

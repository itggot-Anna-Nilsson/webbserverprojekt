class Get < Sinatra::Base

    enable :sessions

    get '/' do
    # if session[:admin]
    #     @admin = true
    # end
     slim :'start'
    end

end    
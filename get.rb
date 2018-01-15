class Get < Sinatra::Base

    enable :sessions

    get '/'
    if session[:admin]
        @admin = true
    end
    slim :'login'
    end

end    
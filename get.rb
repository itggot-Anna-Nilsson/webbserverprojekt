class Get < Sinatra::Base

    enable :sessions

    get '/' do
        if session[:admin]
            @admin = true
        end
        slim :'login'
    end
    
    get '/kampanjer' do
        if session[:admin]
            @campaigns = Kampanj.all
            slim :'kampanjer'
        else
            halt 401, slim(:forbidden, layout: false)
        end
    end

    post '/add_kampanj' do
        namn = params['namn']
        status = params['status']
        Kampanj.add_kampanj(namn, status, self)
    end

    get '/kampanj/:id/:name' do
        db = SQLite3::Database.open('db/db.sqlite') 
        id = params['id']        
        db.execute('SELECT * FROM logs WHERE kampanj_id is ?', id) 
        slim :'kampanj'

        #implementering av block, tillkommer 
        # Kampanj.one( {id: 1})
        # Kampanj.one( {name: "woot"} )

        # Kampanj.all( {status: :active})

        # Kampanj.all_active

    end

    #ska tas bort
    #skulle kunna ta ut kampanj id här (???)
    get '/logs' do
        if session[:admin]
           @all_logs = Logs.all
           slim :'logs'
        else
            halt 401, slim(:forbidden, layout: false)
        end
    end

    post '/remove_log/:id' do
        id = params['id']          
        Logs.remove_log(id, self)      
    end

    post '/add_log' do
        titel = params['title']
        kampanj = params['kampanj']
        text = params['log']
        picture = params['picture']
        Logs.add_log(titel, kampanj, text, picture, self)
    end

    post '/login' do #test - 123
        username = params['username']
        password = params['password']
        User.login(username, password, self)
    end

    post '/new_user' do
        username = params['username']
        password = params['password']
        key = params['key']
        User.new_user(username, password, key, self)
    end

    post '/logout' do
        session.destroy
        redirect '/'
    end

    get '/wrongkey' do
        slim :'wrongkey'
    end
    
end
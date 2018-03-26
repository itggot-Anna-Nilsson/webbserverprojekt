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

    post '/kampanj/:kampanj_id/remove' do
        Kampanj.remove_kampanj( params['kampanj_id'], self)
    end

    #HALVKLAR
    post '/kampanj/:kampanj_id/add_player' do
        Kampanj.add_player(params['user_name'], params['kampanj_id'], self)
    end


    get '/kampanj/:id/:name' do       
       if session[:admin]
            id = params['id']
            @kampanj = Kampanj.one(id)
            @all_logs = Logs.all(kampanj_id: id) 
            slim :'kampanj'
        else
            halt 401, slim(:forbidden, layout: false)
        end

        #implementering av block, tillkommer 
        # Kampanj.one( {id: 1})
        # Kampanj.one( {name: "woot"} )
        # Kampanj.all( {status: :active})
        # Kampanj.all_active
    end
    
    post '/kampanj/:kampanj_id/log/:log_id/remove' do
        Logs.remove_log(params['log_id'], params['kampanj_id'], self)
    end

    post '/add_log' do
        titel = params['title']
        kampanj = params['kampanj_id']
        text = params['log']
        picture = params['picture']
        kampanj_namn = params['kampanj_namn']
        Logs.add_log(titel, kampanj, text, picture, kampanj_namn, self)
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
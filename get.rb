class Get < Sinatra::Base

    enable :sessions
    register Sinatra::Flash

    before do
        if session[:admin]
            @admin = true
        end
        allowed_urls = ['/', '/login', '/wrongkey', '/forbidden']
        unless allowed_urls.include?(request.path)
            redirect "/forbidden" unless @admin 
        end
    end

    get '/' do
        slim :'login'
    end
    
    get '/kampanjer' do
        @campaigns = Kampanj.all
        slim :'kampanjer'
    end

    post '/add_kampanj' do
        namn = params['namn']
        status = params['status']
        Kampanj.add(Name: namn, Status: status)
        redirect 'kampanjer'
    end

    post '/kampanj/:kampanj_id/remove' do
        Kampanj.remove_kampanj( params['kampanj_id'], self)
    end

    post '/kampanj/:kampanj_id/add_player' do
        Kampanj.add_player(params['user_name'], params['kampanj_id'], self)
    end

    get '/kampanj/:id/:name' do       
        id = params['id']
        @kampanj = Kampanj.one(id)
        @all_logs = Logs.all(kampanj_id: id)
        @all_players = Kampanj.users(id) 
        slim :'kampanj'
    end
    
    post '/kampanj/:kampanj_id/log/:log_id/remove' do
        Logs.remove_log(params['log_id'], params['kampanj_id'], self)
    end

    post '/add_log' do
        titel = params['title']
        kampanj = params['kampanj_id']
        text = params['log']
        picture = params['picture']
        namn = params['kampanj_namn'] #används för att redirecta till rätt kampanj
        Logs.add(kampanj_id: kampanj, Titel: titel, Text: text, Picture: picture)
        redirect "/kampanj/#{id}/#{namn.to_slug}"
    end

    post '/login' do #test - 123
        username = params['username']
        password = params['password']
        User.login(username, password, self)
    end

    post '/new_user' do
        username = params['username']
        password = params['password']
        key = params['key'] #4242
        User.new_user(username, password, key, self)
    end

    post '/logout' do
        session.destroy
        redirect '/'
    end

    get '/wrongkey' do
        slim :'wrongkey'
    end

    get '/forbidden'do
        halt 401, slim(:forbidden, layout: false)
    end
    
end
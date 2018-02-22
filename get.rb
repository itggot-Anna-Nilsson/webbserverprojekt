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
            db = SQLite3::Database.open('db/db.sqlite') 
            @campaigns = db.execute('SELECT id, name FROM Campaigns')
            slim :'kampanjer'
        else
            halt 401, slim(:forbidden, layout: false)
        end
    end

    get '/kampanj/:id/:name' do
        db = SQLite3::Database.open('db/db.sqlite') 
        id = params['id']        
        db.execute('SELECT * FROM logs WHERE kampanj_id is ?', id) 
        slim :'mutant'
    end

########################################
    post '/add_kampanj' do
        namn = params['namn']
        status = params['status']
        Kampanj.add_kampanj(namn, status, self)
    end

    get '/logs' do
        if session[:admin]
           @all_logs = Logs.loggar
           slim :'logs'
        else
            halt 401, slim(:forbidden, layout: false)
        end
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

    #halvklar implementering
    #måste fixa routen



#-------------------------------------------------------------------------

    post '/remove_log/:id' do
        db = SQLite3::Database.open('db/db.sqlite')
        id = params['id']          
        db.execute('DELETE FROM logs WHERE id is ?', id) 
        redirect '/logs'       
    end

    post '/add_log' do
        #Logs.add_log(self)


        db = SQLite3::Database.open('db/db.sqlite')
        titel = params['title']
        kampanj = params['kampanj']
        text = params['log']
        picture = params['picture']
        postdate = Time.now.strftime("%H:%M %d-%m-%Y")  
        db.execute('INSERT INTO logs (kampanj_id, Title, Text, Picture, Postdate) VALUES (?,?,?,?,?)', [kampanj, titel, text, picture, postdate])        
        redirect '/logs'
    end
    
end
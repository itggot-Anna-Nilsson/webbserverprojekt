class Get < Sinatra::Base

    enable :sessions

    get '/' do
        if session[:admin]
            @admin = true
        end
        slim :'login'
    end
    
    get '/start' do
        if session[:admin]
            slim :'start'
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

#-------------------------------------------------------------------------

    get '/logs' do
        if session[:admin]
            db = SQLite3::Database.open('db/db.sqlite')            
            @all_logs = db.execute('SELECT * FROM logs')
            slim :'logs'
        else
            halt 401, slim(:forbidden, layout: false)
        end
    end

    post '/remove_log/:id' do
        db = SQLite3::Database.open('db/db.sqlite')
        id = params['id']          
        db.execute('DELETE FROM logs WHERE id is ?', id) 
        redirect '/logs'       
    end

    post '/add_log' do
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
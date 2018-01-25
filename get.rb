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
        db = SQLite3::Database.open('db/db.sqlite')
        username = params['username']
        password = params['password']
        key = params['key']

        username_list = db.execute('SELECT name FROM Users')[0]
        unused_username = true

        p username_list
        if username_list != nil
            for i in username_list
                if username == i
                    unused_username = false
                end
            end
        end

        if key == "4242" && unused_username
            cleartext = username + password
            hash = BCrypt::Password.create(cleartext)
            salt = hash.salt
            db.execute('INSERT INTO users (name, hash) VALUES(?,?)', [username, hash])
            session[:admin] = true
            session[:username] = username
            redirect '/start'
        else 
            redirect '/wrongkey'
        end
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
            @all_logs = db.execute('SELECT * FROM Posts')
            slim :'logs'
        else
            halt 401, slim(:forbidden, layout: false)
        end
    end

    post '/remove_logg/:id' do
        db = SQLite3::Database.open('db/db.sqlite')
        id = params['id']          
        db.execute('DELETE FROM Posts WHERE id is ?', id) 
        redirect '/logs'       
    end

    post '/add_logg' do
        db = SQLite3::Database.open('db/db.sqlite')
        titel = params['date']
        summary = params['summary']
        text = params['description']   
        db.execute('INSERT INTO Loggar (titel, test, picture, Post-date) VALUES (?,?,?)', [Titel, Text, Picture, Post-date])        
        redirect '/logg'
    end
    
end
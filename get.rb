class Get < Sinatra::Base

    enable :sessions

    get '/' do
        if session[:admin]
            @admin = true
        end
        slim :'login'
    end
    
    get '/home' do
        if session[:admin]
            slim :'home'
        else
            halt 401, slim(:forbidden, layout: false)
        end
    end

    post '/login' do #test - 123
        db = SQLite3::Database.open('db/db.sqlite')        
        username = params['username']
        password = params['password']
        hash = db.execute('SELECT password FROM Users WHERE username IS ?', username)[0][0]
        stored_password = BCrypt::Password.new(hash)
        if stored_password == username + password
            session[:admin] = true
            session[:username] = username
            redirect '/start'
        end
        redirect '/'
    end

    post '/new_user' do
        db = SQLite3::Database.open('db/db.sqlite')
        username = params['username']
        password = params['password']
        key = params['key']

        username_list = db.execute('SELECT username FROM Users')[0]
        unused_username = true

        for i in username_list
            if username == i
                unused_username = false
            end
        end

        if key == "4242" && unused_username
            cleartext = username + password
            hash = BCrypt::Password.create(cleartext)
            salt = hash.salt
            db.execute('INSERT INTO users (password, salt, username) VALUES(?,?,?)', [hash, salt, username])
            session[:admin] = true
            session[:username] = username
            redirect '/home'
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
    
end
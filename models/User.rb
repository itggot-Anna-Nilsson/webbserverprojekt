class User

    attr_reader :login

    def login (username, password)
        db = SQLite3::Database.open('db/db.sqlite')        
        hash = db.execute('SELECT password FROM Users WHERE username IS ?', username)[0][0]
        stored_password = BCrypt::Password.new(hash)
        if stored_password == username + password
            session[:admin] = true
            session[:username] = username
            redirect '/start'
        end
        redirect '/'
    end

end
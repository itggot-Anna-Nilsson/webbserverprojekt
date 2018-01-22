class User

    attr_reader :login

    def self.login (username, password, get)
        db = SQLite3::Database.open('db/db.sqlite')        
        hash = db.execute('SELECT hash FROM Users WHERE name IS ?', username)[0][0]
        stored_password = BCrypt::Password.new(hash)
        if stored_password == username + password
            get.session[:admin] = true
            get.session[:username] = username
            get.redirect '/start'
        end
        get.redirect '/'
    end

    def self.new_user
    end

end
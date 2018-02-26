class User

    attr_reader :username

    def self.login (username, password, get)
        db = SQLite3::Database.open('db/db.sqlite')        
        hash = db.execute('SELECT hash FROM Users WHERE name IS ?', username)[0][0]
        stored_password = BCrypt::Password.new(hash)
        if stored_password == username + password
            get.session[:admin] = true
            get.session[:username] = username
            get.redirect '/kampanjer'
        end
        get.redirect '/'
    end

    def self.new_user (username, password, key, get)
        db = SQLite3::Database.open('db/db.sqlite')
        username_list = db.execute('SELECT name FROM Users')[0]
        unused_username = true

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
            get.session[:admin] = true
            get.session[:username] = username
            get.redirect '/kampanjer'
        else 
            get.redirect '/wrongkey'
        end

    end


end
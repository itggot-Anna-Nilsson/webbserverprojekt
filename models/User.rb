class User < Bas

    attr_reader :username

    def self.login (username, password, get)
        hash = self.db.execute('SELECT hash FROM Users WHERE name IS ?', username)[0] # en tom array ger [] men [0] på en tom array returnerar nil
        if hash 
            stored_password = BCrypt::Password.new(hash[0])
            if stored_password == username + password
                get.session[:admin] = true
                get.session[:username] = username
                get.redirect '/kampanjer'
            end
        else
            get.redirect '/wrongkey'
        end
    end

    def self.new_user (username, password, key, get)
        username_list = self.db.execute('SELECT name FROM Users')[0]
        usernames = []
        for i in username_list
            usernames << i[0]
        end
        unused_username = !(usernames.include?(username))

        if key == "4242" && unused_username
            cleartext = username + password
            hash = BCrypt::Password.create(cleartext)
            self.db.execute('INSERT INTO users (name, hash) VALUES(?,?)', [username, hash])
            get.session[:admin] = true
            get.session[:username] = username
            get.redirect '/kampanjer'
        else 
            get.redirect '/wrongkey'
        end

    end
end
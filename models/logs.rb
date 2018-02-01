class Logs

    def self.loggar()
        db = SQLite3::Database.open('db/db.sqlite')            
        return db.execute('SELECT * FROM logs')   
    end

    def self.remove_log(get)
        db = SQLite3::Database.open('db/db.sqlite')         
        db.execute('DELETE FROM logs WHERE id is ?', id) 
        get.redirect '/logs'
    end  

    def self.add_log(get)
        db = SQLite3::Database.open('db/db.sqlite')
        # kampanj = params['kampanj']
        # måste hitta rätt id til kampanjnamnet
        postdate = Time.now.strftime("%H:%M %d-%m-%Y")  
        db.execute('INSERT INTO logs (kampanj_id, Title, Text, Picture, Postdate) VALUES (?,?,?,?,?)', [kampanj, titel, text, picture, postdate])        
        get.redirect '/logs'
    end


end
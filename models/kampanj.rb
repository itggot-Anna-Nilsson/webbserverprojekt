class Kampanj

    def self.get_kampanjer
        db = SQLite3::Database.open('db/db.sqlite')            
        return db.execute('SELECT * FROM Campaigns') 
    end

    def self.add_kampanj(namn, status, get)
        db = SQLite3::Database.open('db/db.sqlite')
        db.execute('INSERT INTO Campaigns(Name,Status) VALUES(?,?)',[namn, status])
        get.redirect 'kampanjer'
    end

    def self.status
    end

    # placeholders

    def self.kommaåtloggar
    end

    def self.kommaåtusers
    end
    
end
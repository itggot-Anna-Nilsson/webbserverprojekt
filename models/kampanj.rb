class Kampanj

    def self.get_kampanjer
        db = SQLite3::Database.open('db/db.sqlite')            
        return db.execute('SELECT * FROM Campaigns') 
    end

    def self.add_kampanj
        db = SQLite3::Database.open('db/db.sqlite')
        db.execute('INSERT INTO Campaigns(Name,Status) VALUES(?,?)',[])
        redirect
    end

    def self.status
    end

    # placeholders

    def self.kommaåtloggar
    end

    def self.kommaåtusers
    end
    
end
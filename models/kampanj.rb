class Kampanj

    def self.get_kampanjer
        db = SQLite3::Database.open('db/db.sqlite')            
        return db.execute('SELECT * FROM Campaigns') 
    end

    def self.add_kampanj
        db = SQLite3::Database.open('db/db.sqlite')
        db.execute('INSERT INTO Campaigns() VALUES(?,?)',[])
    end

    def self.status
    end
    
end
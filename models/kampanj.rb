class Kampanj

    attr_reader :id, :namn, :status

    def initialize(kamp_list)
        @id = kamp_list[0]
        @namn = kamp_list[1]
        @status = kamp_list[2]
    end

    def self.all
        db = SQLite3::Database.open('db/db.sqlite')          
        result_from_db = db.execute('SELECT * FROM Campaigns')
        kamp_list = []
        result_from_db.each do |kampanj|
            kamp_list << self.new(kampanj)
        end  
        return kamp_list
    end

    
    def self.one(hash)
        db = SQLite3::Database.open('db/db.sqlite')
        one = db.execute('SELECT * FROM Campaigns WHERE id IS ?', hash)[0]
        return self.new(one)
    end

    def self.add_kampanj(namn, status, get)
        db = SQLite3::Database.open('db/db.sqlite')
        db.execute('INSERT INTO Campaigns(Name,Status) VALUES(?,?)',[namn, status])
        get.redirect 'kampanjer'
    end

    
    def self.remove_kampanj(kampanj_id, get )
        db = SQLite3::Database.open('db/db.sqlite')      
        db.execute('DELETE FROM Campaigns WHERE id is ?', kampanj_id)
        get.redirect "/kampanjer"
    end 

    #UNDER HERE
    def self.add_player(user_name, kampanj_id, get)
        db = SQLite3::Database.open('db/db.sqlite')
        kampanj = Kampanj.one(kampanj_id) #något som blir fel här
        user_id = db.execute('SELECT id FROM Users WHERE Name is ?', user_name)[0]
        db.execute('INSERT INTO Memberships(Users_id, Campaign_id) VALUES(?,?)',[user_id, kampanj_id])
        get.redirect "/kampanj/#{kampanj.id}/#{kampanj.namn.to_slug}"
    end

    # placeholder

    def self.users
        db = SQLite3::Database.open('db/db.sqlite')
        kampanj = Kampanj.one(kampanj_id)
        users = db.execute('SELECT ALL FROM  Memberships WHERE Campaign_id IS ?', kampanj_id)
        #ska skapa en lista/ ett object med alla spelare 
        #i respektive kampanj
        get.redirect "/kampanj/#{kampanj.id}/#{kampanj.namn.to_slug}"
    end
    
end
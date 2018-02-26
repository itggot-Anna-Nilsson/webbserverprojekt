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

    #VET INTE OM JAG KOMMER HA ID, behöver ha något
    def self.one(hash)
        db = SQLite3::Database.open('db/db.sqlite')
        one = db.execute('SELECT * FROM Campaigns WHERE id IS ?', @id)
        return one
    end

    def self.add_kampanj(namn, status, get)
        db = SQLite3::Database.open('db/db.sqlite')
        db.execute('INSERT INTO Campaigns(Name,Status) VALUES(?,?)',[namn, status])
        get.redirect 'kampanjer'
    end


    # placeholders

    def self.loggar
    end

    def self.users
    end
    
end
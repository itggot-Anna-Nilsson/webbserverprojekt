class Logs

    attr_reader :id, :kampanj_id, :titel, :text, :picture, :postdate

    def initialize(log_list)
        @id = log_list[0]
        @kampanj_id = log_list[1]
        @titel = log_list[2]
        @text = log_list[3]
        @picture = log_list[4] #picture kommer att vara nil många gånger, hur fungerar det?
        @postdate = log_list[5]
    end


    def self.all
        db = SQLite3::Database.open('db/db.sqlite')            
        result_from_db = db.execute('SELECT * FROM logs')
        log_list = []
        result_from_db.each do |log|
            log_list << self.new(log)
        end
        return log_list
    end

    # def self.loggar()
    #     db = SQLite3::Database.open('db/db.sqlite')            
    #     return db.execute('SELECT * FROM logs')   
    # end

    def self.remove_log(id, get)
        db = SQLite3::Database.open('db/db.sqlite')         
        db.execute('DELETE FROM logs WHERE id is ?', id) 
        get.redirect '/logs'
    end  

    def self.add_log(titel, kampanj, text, picture, get)
        db = SQLite3::Database.open('db/db.sqlite')
        # måste hitta rätt id til kampanjnamnet
        postdate = Time.now.strftime("%H:%M %d-%m-%Y")  
        db.execute('INSERT INTO logs (kampanj_id, Title, Text, Picture, Postdate) VALUES (?,?,?,?,?)', [kampanj, titel, text, picture, postdate])        
        get.redirect '/logs'
    end


end
class Logs

    attr_reader :id, :kampanj_id, :titel, :text, :picture, :postdate

    def initialize(log_list)
        @id = log_list[0]
        @kampanj_id = log_list[1]
        @titel = log_list[2]
        @text = log_list[3]
        @picture = log_list[4] 
        @postdate = log_list[5]
    end

    def self.all(*args)
        args = args[0]
        db = SQLite3::Database.open('db/db.sqlite')            
        db_s = "SELECT * FROM logs"
        if args
            for key in args.keys
                if key == args.keys[0]
                    db_s += " WHERE"
                else 
                    db_s += " AND"
                end
                db_s += " #{key.to_s} IS #{args[key]}"
            end
        end

        result_from_db = db.execute(db_s)
        log_list = []
        result_from_db.each do |log|
            log_list << self.new(log)
        end
        return log_list
    end

    def self.remove_log(id, get, kampanj_id, kampanj_namn )
        db = SQLite3::Database.open('db/db.sqlite')         
        db.execute('DELETE FROM logs WHERE id is ?', id) 
        kampanj_id = kampanj_id
        kampanj_namn = kampanj_namn
        get.redirect "/kampanj/#{kampanj_id}/#{kampanj_namn.to_slug}"
        # kampanj_namn verkar ta "remove log som värde"
    end  

    def self.add_log(titel, kampanj, text, picture, kampanj_namn, get)
        db = SQLite3::Database.open('db/db.sqlite')
        postdate = Time.now.strftime("%H:%M %d-%m-%Y")  
        db.execute('INSERT INTO logs (kampanj_id, Title, Text, Picture, Postdate) VALUES (?,?,?,?,?)', [kampanj, titel, text, picture, postdate])        
        id = kampanj
        namn = kampanj_namn
        get.redirect "/kampanj/#{id}/#{namn.to_slug}"
    end


end
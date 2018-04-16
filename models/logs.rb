class Logs < Bas

    attr_reader :id, :kampanj_id, :titel, :text, :picture, :postdate

    table_name('logs')
    columns(['kampanj_id', 'titel', 'text', 'picture', 'postdate'])

    def initialize(all_list)
        @id = all_list[0]
        @kampanj_id = all_list[1]
        @titel = all_list[2]
        @text = all_list[3]
        @picture = all_list[4] 
        @postdate = all_list[5] 
    end

    def self.remove_log(id, kampanj_id, get )
        db = SQLite3::Database.open('db/db.sqlite')      
        db.execute('DELETE FROM logs WHERE id is ?', id)
        kampanj = Kampanj.one(kampanj_id)
        get.redirect "/kampanj/#{kampanj.id}/#{kampanj.namn.to_slug}"
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
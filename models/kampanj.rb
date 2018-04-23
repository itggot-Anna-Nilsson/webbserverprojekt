class Kampanj < Bas

    attr_reader :id, :namn, :status

    table_name('Campaigns')
    columns(['namn', 'status'])

    def initialize(all_list)
        @id = all_list[0]
        @namn = all_list[1]
        @status = all_list[2]
    end

    def self.add_player(user_name, kampanj_id, get)
        db = SQLite3::Database.open('db/db.sqlite')
        kampanj = Kampanj.one(kampanj_id)
        user_id = db.execute('SELECT id FROM Users WHERE Name is ?', user_name)[0]
        if user_id != nil
            db.execute('INSERT INTO Memberships(Users_id, Campaign_id) VALUES(?,?)',[user_id, kampanj_id])
            get.flash[:error] = "Användaren tillagd."
        else
            get.flash[:error] = "Användaren finns inte." 
        end
        get.redirect "/kampanj/#{kampanj.id}/#{kampanj.namn.to_slug}"
    end

    def self.users(id)
        db = SQLite3::Database.open('db/db.sqlite')
        users = db.execute('SELECT Name FROM Users WHERE id IN (SELECT Users_id FROM Memberships WHERE Campaign_id IS ?)', id)
        return users
    end
    
end
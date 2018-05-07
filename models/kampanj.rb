class Kampanj < Bas

    attr_reader :id, :namn, :status, :gm

    table_name('Campaigns')
    column(['namn', 'status', 'admin'])

    def initialize(all_list)
        @id = all_list[0]
        @namn = all_list[1]
        @status = all_list[2]
        @gm = all_list[3]
    end

    def add_player(user_name, get)
        db = SQLite3::Database.open('db/db.sqlite')
        user_id = db.execute('SELECT id FROM Users WHERE Name is ?', user_name)[0]
        if user_id != nil
            db.execute('INSERT INTO Memberships(Users_id, Campaign_id) VALUES(?,?)',[user_id, @id])
            get.flash[:error] = "Användaren tillagd."
        else
            get.flash[:error] = "Användaren finns inte." 
        end
    end

    def self.users(id)
        db = SQLite3::Database.open('db/db.sqlite')
        users = db.execute('SELECT Name FROM Users WHERE id IN (SELECT Users_id FROM Memberships WHERE Campaign_id IS ?)', id)
        return users
    end
    
end
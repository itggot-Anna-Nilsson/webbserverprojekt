class Bas

    def initialize()
    end

    def self.table_name(name)
        @table_name = name
    end

    def self.columns(columns)
        @columns = columns
    end

    def self.one(hash)
        db = SQLite3::Database.open('db/db.sqlite')
        db_s = "SELECT * FROM#{@table_name}WHERE id IS ?"
        one = db.execute(db_s, hash)[0]
        return self.new(one)
    end

    def self.all(*args)
        args = args[0]
        db = SQLite3::Database.open('db/db.sqlite')            
        db_s = "SELECT * FROM #{@table_name}"
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
        all_list = []
        result_from_db.each do |one|
            all_list << self.new(one)
        end
        return all_list
    end

    def add


    end 

    def remove

        
    end 

end
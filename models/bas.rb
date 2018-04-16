class Bas

    def initialize()
    end

    #Creates a variable containing tablename
    #
    #@params table_name [String] The table name
    #@return [String] A string containing the table name
    def self.table_name(name)
        @table_name = name
    end

    #Creates a variable containing the columns of the table
    #
    #@params columns [Array] A list containing the column names
    #@return [Array] A list containing the column names
    def self.columns(columns)
        @columns = columns
    end

    #Creates the route to the database unless it already exists
    #
    #@return [SQLite3::Database] the database
    def self.db
        @db ||= SQLite3::Database.open('db/db.sqlite')
        return @db
    end

    #Creates an Array containing one row from the database
    #
    #@param hash [String] contains the id 
    #@return [Array] the list containing one row from the database
    def self.one(hash)
        db_s = "SELECT * FROM #{@table_name} WHERE id IS ?"
        one = db.execute(db_s, hash)[0]
        return self.new(one)
    end
    
    #Creates an Array containing multiple rows from the database
    #
    #@param *args [String] contains the column name and value
    #@return [Array] the list containing the specified columns 
    def self.all(*args)
        args = args[0]            
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

    #Kampanj.add(title: params['title'], ...)
    #User.add(username: params['username'], password = password_hash)
    def add(hash)
        submitted_columns = hash.keys #ger alla nycklar den skickat med 
    end 

    def remove

        
    end 

end
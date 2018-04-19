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
        query = "SELECT * FROM #{@table_name} WHERE id IS ?"
        one = db.execute(query, hash)[0]
        return self.new(one)
    end
    
    #Creates an Array containing multiple rows from the database
    #
    #@param *args [String] contains the column name and value
    #@return [Array] the list containing the specified columns 
    def self.all(*args)
        args = args[0]            
        query = "SELECT * FROM #{@table_name}"
        if args # korta ner (ternary if)
            for key in args.keys
                if key == args.keys[0]
                    query += " WHERE"
                else 
                    query += " AND"
                end
                query += " #{key.to_s} IS #{args[key]}"
            end
        end

        result_from_db = db.execute(query)
        all_list = []
        result_from_db.each do |one|
            all_list << self.new(one)
        end
        return all_list
    end

    #Kampanj.add(title: params['title'], ...)
    #User.add(username: params['username'], password = password_hash)
    def self.add(hash)
        submitted_columns = "" #ger alla nycklar den skickat med
        (hash.length).times do |i|
            submitted_columns += hash.keys[i].to_s #måste fixa en komma emellan
        end
        p submitted_columns

        value = ""
        (hash.length-1).times do 
            value += "?, "
        end
        value += "?"

        query = "INSERT INTO #{@table_name}(#{submitted_columns.to_s}) VALUES(#{value})"
        p query
        db.execute(query, hash.values)
    end 

    def self.remove
        
    end 

end
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
    def self.column(columns)
        #@columns = columns
        @columns = []
        for i in columns
            @columns << i 
        end 
    end

    #Creates the route to the database unless it already exists
    #
    #@return [SQLite3::Database] the database
    def self.db
        @db ||= SQLite3::Database.open('db/db.sqlite')
    end

    #Creates an Array containing one row from the database
    #
    #@param hash [Hash] contains the id 
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

        if args
            for key in args.keys
                query += key == args.keys[0] ? " WHERE" : " AND"
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

    #Takes a hash's keys and arrange them into a string for SQLite use
    #
    #@param hash [Hash] contains the column keys and value
    #@return [String] a string containing the keys from the hash
    def self.submitted_columns(hash)
        submitted_columns = ""
        (hash.length-1).times do |i|
            submitted_columns += hash.keys[i].to_s 
            submitted_columns += ", "
        end
        submitted_columns += hash.keys[-1].to_s
        return submitted_columns
    end

    #Takes a hash's lenght and returns an equal amount of "?" for SQLite use
    #
    #@param hash [Hash] contains the column keys and value
    #@return [String] a string containing an equal amount of "?"
    def self.value(hash)
        value = ""
        (hash.length-1).times do 
            value += "?, "
        end
        value += "?"
        return value
    end

    #Adds new values (rows) to the database
    #
    #@param hash [Hash] contains the column name and value
    #@returns nothing
    def self.add(hash)
        value = self.value(hash)
        columns = self.submitted_columns(hash)
        query = "INSERT INTO #{@table_name}(#{column}) VALUES(#{value})"
        db.execute(query, hash.values)
    end 

    #Removes data (rows) from the database
    #
    #@param id [String] contains the id of the specific row
    #@returns nothing
    def self.remove(id)
        query = "DELETE FROM #{@table_name} WHERE id IS ?"
        db.execute(query, id)
    end 

end
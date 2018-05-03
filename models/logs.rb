class Logs < Bas

    attr_reader :id, :kampanj_id, :titel, :text, :picture, :postdate

    table_name('logs')
    column(['kampanj_id', 'titel', 'text', 'picture', 'postdate'])

    def initialize(all_list)
        @id = all_list[0]
        @kampanj_id = all_list[1]
        @titel = all_list[2]
        @text = all_list[3]
        @picture = all_list[4] 
        @postdate = all_list[5] 
    end
end
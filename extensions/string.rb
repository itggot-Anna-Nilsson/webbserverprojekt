class String

    def to_slug
        slug = self.downcase.strip.gsub(' ', '-').gsub('ö', 'o').gsub('å', 'a').gsub('ä', 'a').gsub(/[^\w-]/, '')
        return slug
    end

end
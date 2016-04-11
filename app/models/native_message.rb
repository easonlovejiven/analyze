class NativeMessage < ActiveRecord::Base

	def show_genre
    {1 => "type1", 2 => "type2", 3 => "type3"}[self.genre]
  end

end

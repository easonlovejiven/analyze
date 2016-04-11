class DayMessage < ActiveRecord::Base

	def show_genre
    {1 => "type1", 2 => "type2", 3 => "type3"}[self.genre]
  end

  def self.fetch_datas(date_mark)
  	DayMessage.where(day_mark: date_mark)
  end

end

class SumMessage < ActiveRecord::Base

	def show_genre
    {1 => "type1", 2 => "type2", 3 => "type3"}[self.genre]
  end
  class << self
	  # parse date
	  def parse_mark_date(type, date_mark)
	  	if type == "day"
	      if date_mark.blank?
	        # 默认当天day
	        date_mark = Time.now.to_s[0, 8]
	      else
	        # 截取成day 如下：
	        # "2016/04/13 - 10" => 20160413
	        date_mark[0,10].gsub(/\//, '')
	      end
	    else
	      if date_mark.blank?
	        # 默认当天day
	        date_mark = Time.now.to_s
	      else
	        # 截取成hour 如下:
	        # "2016/04/13 - 10" => 2016041310
	        date_mark.gsub(/\//, '').gsub(/ /, '').gsub(/-/, '')
	      end
	    end
	  end

	  # before month
	  def parse_before_month
	  	# 以time_line为坐标轴吐前一个月的数据
	    time_line = Time.now.to_s
	    if time_line[4,1].to_i.zero?
	    	before_date = time_line.gsub(time_line[5, 1], "#{ time_line[5,1].to_i - 1 }")
	    elsif time_line[5, 1].to_i.zero?
	    	before_date = time_line.gsub(time_line[4, 2], "#{ "0"+(before_date[4,2].to_i - 1).to_s }")
	    else
	    	before_date = time_line.gsub(time_line[4, 2], "#{ time_line[4,2].to_i - 1 }")
	    end
	  end

	  # 数据分析（吐给前端上一个月的数据格式／不满一个月吐出所有数据）
	  def analyze_before_month_dates(post_id)
	  	HourMessage.where("post_id = #{post_id} and hour_mark < #{parse_before_month}")
	  end

	end

end

class DayMessageWorker

	@queue = :day_message

  # hour_mark：“2016033108”
  # day_mark：“20160331”

  def self.perform
  	hour_dates = HourMessage.find_by_sql("select genre, hour_mark, post_id, sum(impression_count) as impression_count,sum(click_count) as click_count,sum(comment_count) as comment_count,sum(praise_count) as praise_count,sum(qq_share) as qq_share,sum(wechat_share) as wechat_share,sum(weibo_share) as weibo_share from hour_messages group by post_id")
	  hour_dates.each do |line|
	  	message_all = DayMessage.where("post_id = '#{line.post_id}' and day_mark = '#{line.hour_mark[0, 8]}'")[0]
	  	message_post = DayMessage.where("post_id = '#{line.post_id}'")
	  	message_mark = DayMessage.where("day_mark = '#{line.hour_mark[0, 8]}'")
	  	if message_all.blank? || message_post.blank? || (message_mark.blank? && message_post.present?)
	  		DayMessage.create(post_id: line.post_id, impression_count: line.impression_count, click_count: line.click_count, comment_count: line.comment_count, praise_count: line.praise_count, qq_share: line.qq_share, wechat_share: line.wechat_share, weibo_share: line.weibo_share, genre: line.genre, day_mark: line.hour_mark[0, 8])
	  	elsif
	  		message_all.update(impression_count: message_all.impression_count + line.impression_count, click_count: message_all.click_count + line.click_count, comment_count: message_all.comment_count + line.comment_count, praise_count: message_all.praise_count + line.praise_count, qq_share: message_all.qq_share + line.qq_share, wechat_share: message_all.wechat_share + line.wechat_share, weibo_share: message_all.weibo_share + line.weibo_share)
	  	end
	  end
  end

end
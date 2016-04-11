class HourMessageWorker

	@queue = :hour_message

	# hour_mark：“2016033108”
  # day_mark：“20160331”
  
  def self.perform
  	if Document.final_document
		  Document.read_file_dates.each do |line|
		  	message_all = HourMessage.where("post_id = '#{line[0]}' and hour_mark = '#{line[9]}'")[0]
		  	message_post = HourMessage.where(post_id: line[0])
		  	message_mark = HourMessage.where(hour_mark: line[9])
		  	if message_all.blank? || message_post.blank? || (message_mark.blank? && message_post.present?)
		  		HourMessage.create(post_id: line[0], impression_count: line[1], click_count: line[2], comment_count: line[3], praise_count: line[4], qq_share: line[5], wechat_share: line[6], weibo_share: line[7], genre: line[8], hour_mark: line[9])
		  	elsif
		  		message_all.update(impression_count: message_all.impression_count + line[1], click_count: message_all.click_count + line[2], comment_count: message_all.comment_count + line[3], praise_count: message.praise_count + line[4], qq_share: message_all.qq_share + line[5], wechat_share: message_all.wechat_share + line[6], weibo_share: message_all.weibo_share + line[7])
		  	end
		  end
		end
  end

end
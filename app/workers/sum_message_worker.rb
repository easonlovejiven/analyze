class SumMessageWorker

  @queue = :sum_message

  # hour_mark：“2016033108”
  # day_mark：“20160331”

  def self.perform
    sum_dates = DayMessage.find_by_sql("select genre, post_id, sum(impression_count) as impression_count,sum(click_count) as click_count,sum(comment_count) as comment_count,sum(praise_count) as praise_count,sum(qq_share) as qq_share,sum(wechat_share) as wechat_share,sum(weibo_share) as weibo_share from day_messages group by post_id")
    sum_dates.each do |line|
      message = SumMessage.find_by_post_id(line.post_id)
      if message.blank?
        SumMessage.create(post_id: line.post_id, impression_count: line.impression_count, click_count: line.click_count, comment_count: line.comment_count, praise_count: line.praise_count, qq_share: line.qq_share, wechat_share: line.wechat_share, weibo_share: line.weibo_share, genre: line.genre)
      else
        message.update(post_id: line.post_id, impression_count: line.impression_count+message.impression_count, click_count: line.click_count+message.click_count, comment_count: line.comment_count+message.comment_count, praise_count: line.praise_count+message.praise_count, qq_share: line.qq_share+message.qq_share, wechat_share: line.qq_share+message.wechat_share, weibo_share: line.weibo_share+message.weibo_share, genre: line.genre)
      end
    end
  end

end
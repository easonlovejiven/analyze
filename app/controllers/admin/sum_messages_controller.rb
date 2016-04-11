# coding: utf-8
class Admin::SumMessagesController < Admin::BaseController

  def index
  end

  def more_sum_message
    @search = params[:search][:value] ? params[:search][:value] : ""
    @per_page = params[:per_page] ? params[:per_page] : 10
    page = params[:page] || 1
    start = params[:start].to_i || 0
    length = params[:length] ? params[:length].to_i : 10
    page = (start / length) + 1
    @per_page = length
    if params[:optionsRadios].blank? && params[:dateMark].blank?
      # 默认sum_messages
      sum_messages = SumMessage.where(["post_id like ?", "%%#{@search}%%"]).paginate(page: page , per_page: @per_page).order("id DESC")
      data = sum_messages.collect { |item| {:id => item.id, :post_id => item.post_id, :impression_count => item.impression_count, :click_count => item.click_count, :comment_count => item.comment_count, :praise_count => item.praise_count, :qq_share => item.qq_share, :wechat_share => item.wechat_share, :weibo_share => item.weibo_share, :genre => item.show_genre} }
      has_more = (sum_messages.length == 0 ? false : true)
      all_count = sum_messages.count
    else
      # day_message or hour_messages
      date_mark = SumMessage.parse_mark_date(params[:optionsRadios], params[:dateMark])
      messages = date_messsage(params[:optionsRadios], date_mark)
      messages = messages.where(["post_id like ?", "%%#{@search}%%"]).paginate(page: page , per_page: @per_page).order("id DESC")
      data = messages.collect { |item| {:id => item.id, :post_id => item.post_id, :impression_count => item.impression_count, :click_count => item.click_count, :comment_count => item.comment_count, :praise_count => item.praise_count, :qq_share => item.qq_share, :wechat_share => item.wechat_share, :weibo_share => item.weibo_share, :genre => item.show_genre} }
      has_more = (messages.length == 0 ? false : true)
      all_count = messages.count
    end
    draw = params[:draw].to_i + 1
    render :json => {:draw => draw, :has_more => has_more, :start => start, :recordsTotal => all_count, :recordsFiltered => all_count, :data => data }
  end

  def show
    SumMessage.analyze_before_month_dates(params[:id])
  end

  private

  def date_messsage(type, date_mark)
    if type == "day"
      DayMessage.fetch_datas(date_mark)
    else
      HourMessage.fetch_datas(date_mark)
    end
  end

  def sum_message_params
    params.require(:sum_message).permit(:post_id, :impression_count, :click_count, :comment_count, :praise_count, :qq_share, :wechat_share, :weibo_share, :genre)
  end
end
class Document < ActiveRecord::Base

	def show_file_state
    {0 => "未读", 1 => "已读"}[self.file_state]
  end

  # 生成一层文件夹
  Paperclip.interpolates :day do |attachment, style|
    attachment.instance.created_at.strftime("%Y%m%d")
  end

  # 生成两层文件夹
  Paperclip.interpolates :hour do |attachment, style|
    attachment.instance.created_at.strftime("%Y%m%d%H")[attachment.instance.created_at.strftime("%Y%m%d%H").length-2,2]
  end

  has_attached_file :file, 
	:url => "/:attachment/:day/:hour/:basename.:extension", # 文件访问路径
	:path => ":rails_root/public/:attachment/:day/:hour/:basename.:extension" # 文件存放路径 :rails_root 给用户设置存放的root权限
	#validates_attachment_size :avatar, :less_than => 2.megabytes # 文件大小限制
  validates_attachment_content_type :file, content_type: ["text/csv"]

  class << self

    def final_document
      Document.last.file_state.zero? ? true : false
    end

    def read_file_dates
      require 'csv'
      document = Document.last
      if final_document
        document.update(file_state: 1)
        day = document.file_updated_at.to_s[0, 8]
        hour = document.file_updated_at.to_s[8, 2]
        filename = document.file_file_name
        hour_dates = CSV.open "public/files/#{day}/#{hour}/#{filename}"
        hour_dates.read
      end
    end

  end

end

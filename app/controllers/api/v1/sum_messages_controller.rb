class Api::V1::SumMessagesController < Admin::BaseController
	
	def read_file
		result = true
		msg = "successly"
		# 上传操作
		scheduler = Rufus::Scheduler.new
		scheduler.every  '10s'  do
			async_create_message
		end
		# render json: {status: result, msg: msg}
	end

	private

	# 异步任务（定时去跑异步任务晚上计算） rake resque:work QUEUE='*' 
	def async_create_message
		Resque.enqueue(HourMessageWorker)
		Resque.enqueue(DayMessageWorker)
		Resque.enqueue(SumMessageWorker)
	end

end
require 'pathname'
class DataTransfer
	def initialize#初始化数据库链接
		@client = Mysql2::Client.new(host: 'localhost' , username: 'root' , password: '' , database: :qdaily_text , port: 3306)
		@path = File.join(File.dirname(Pathname.new(__FILE__).realpath.to_path))
	end

	def start
		#article paper post user
		cp_articles_and_posts
		cp_users

		#无任何关联
		cp_activities
		cp_apks
		cp_boot_advertisements
		cp_covers
		cp_curiosities
		cp_downloads
		cp_faces
		cp_filters
		cp_paper_categories
		cp_partners
		cp_systems
		cp_tags
		cp_touch_icons

		#与其他表关联
		cp_columnists
		cp_feedbacks
		cp_mount_details
		cp_radars
		cp_subscribes
		cp_reports
		cp_options
		cp_pushes

		#与article paper关联
		cp_books
		cp_categories
		cp_comments
		cp_company_titles
		cp_maps
		cp_messages
		cp_post_relateds
		cp_post_tags
		cp_praises
		cp_questions
		cp_records
		cp_special_columns
	end

	private


	def cp_pushes
		@client.query("SELECT * FROM pushes order by id ASC").each do |push|
			hash = {}
			hash[:id] = push["id"]
			hash[:content] = push["content"]
			hash[:status] = push["status"]
			hash[:genre] = push["genre"]
			hash[:message_id] = push["message_id"]
			hash[:state] = push["state"]
			hash[:created_at] = format_time(push["created_at"])
			hash[:updated_at] = format_time(push["updated_at"])
			hash[:old_id] = push["id"]
			Push.create(hash)
		end
		p 'pushes完成'
	end

	def cp_messages(id = nil)
		messages = if id.nil?
			@client.query("SELECT * FROM messages order by id ASC limit 10000")
		else
			@client.query("SELECT * FROM messages where id > #{id} order by id ASC limit 10000")
		end
		last_message_id = nil
		messages.each do |message|
			last_message_id = message["id"]
			ap = if !message["article_id"].blank? && !message["article_id"].to_s.eql?("0")
				Article.where(id: message["article_id"]).first
			elsif !message["paper_id"].blank? && !message["paper_id"].to_s.eql?("0")
				Paper.where(id: message["paper_id"]).first
			end

			hash = {}
			hash[:id] = message["id"]
			hash[:user_id] = message["user_id"]
			hash[:target_comment_id] = message["target_comment_id"]
			hash[:comment_id] = message["comment_id"]
			hash[:post_id] = ap.blank? ? nil : ap.post_id
			hash[:genre] = message["genre"]
			hash[:state] = message["state"]
			hash[:content] = message["content"]
			hash[:praise_id] = message["praise_id"]
			hash[:title] = message["title"]
			hash[:description] = message["description"]
			hash[:activity_id] = message["activity_id"]
			hash[:url] = message["url"]
			hash[:created_at] = format_time(message["created_at"])
			hash[:updated_at] = format_time(message["updated_at"])
			hash[:old_id] = message["id"]
			Message.create(hash)
		end
		if last_message_id.nil?
			p 'messages完成'
		else
			p last_message_id
			cp_messages(last_message_id)
		end
	end

	def cp_praises(id = nil)
		praises = if id.nil?
			@client.query("SELECT * FROM praises order by id ASC limit 10000")
		else
			@client.query("SELECT * FROM praises where id > #{id} order by id ASC limit 10000")
		end
		last_praise_id = nil
		praises.each do |praise|
			last_praise_id = praise["id"]
			ap = if !praise["article_id"].blank?
				Article.where(id: praise["article_id"]).first
			elsif !praise["paper_id"].blank?
				Paper.where(id: praise["paper_id"]).first
			end

			hash = {}
			hash[:id] = praise["id"]
			hash[:post_id] = ap.blank? ? nil : ap.post_id
			hash[:user_id] = praise["user_id"]
			hash[:ip] = praise["ip"]
			hash[:comment_id] = praise["comment_id"]
			hash[:option_id] = praise["option_id"]
			hash[:created_at] = format_time(praise["created_at"])
			hash[:updated_at] = format_time(praise["updated_at"])
			hash[:old_id] = praise["id"]
			Praise.create(hash)
		end
		if last_praise_id.nil?
			p "praises完成"
		else
			p last_praise_id
			cp_praises(last_praise_id)
		end
	end

	def cp_comments(id = nil)
		comments = if id.nil?
			@client.query("SELECT * FROM comments order by id ASC limit 10000")
		else
			@client.query("SELECT * FROM comments where id > #{id} order by id ASC limit 10000")
		end
		last_comment_id = nil
		comments.each do |comment|
			last_comment_id = comment["id"]
			ap = if !comment["article_id"].blank? && !comment["article_id"].to_s.eql?("0")
				Article.where(id: comment["article_id"]).first
			elsif !comment["paper_id"].blank? && !comment["paper_id"].to_s.eql?("0")
				Paper.where(id: comment["paper_id"]).first
			end

			hash = {}
			hash[:id] = comment["id"]
			hash[:content] = comment["content"]
			hash[:user_id] = comment["user_id"]
			hash[:post_id] = ap.blank? ? nil : ap.post_id
			hash[:parent_id] = comment["parent_id"]
			hash[:approved] = comment["approved"]
			hash[:genre] = comment["genre"]
			hash[:praise_count] = comment["praise_count"]
			hash[:comment_count] = comment["comment_count"]
			hash[:state] = comment["state"]
			hash[:user_name] = comment["user_name"]
			hash[:ip] = comment["ip"]
			hash[:root_id] = comment["root_id"]
			hash[:parent_user_id] = comment["parent_user_id"]
			hash[:created_at] = format_time(comment["created_at"])
			hash[:updated_at] = format_time(comment["updated_at"])
			hash[:old_id] = comment["id"]
			Comment.create(hash)
		end
		if last_comment_id.nil?
			p 'comments完成'
		else
			p last_comment_id
			cp_comments(last_comment_id)
		end
	end

	def cp_records(id = nil)
		records = if id.nil?
			@client.query("SELECT * FROM records order by id ASC limit 10000")
		else
			@client.query("SELECT * FROM records where id > #{id} order by id ASC limit 10000")
		end
		last_record_id = nil
		records.each do |record|

			paper = Paper.where(id: record["paper_id"]).first
			last_record_id = record["id"]
			hash = {}
			hash[:id] = record["id"]
			hash[:post_id] = paper.blank? ? nil : paper.post_id
			hash[:question_id] = record["question_id"]
			hash[:option_id] = record["option_id"]
			hash[:user_id] = record["user_id"]
			hash[:ip] = record["ip"]
			hash[:parent_id] = record["parent_id"]
			hash[:content] = record["content"]
			hash[:status] = record["status"]
			hash[:state] = record["state"]
			hash[:share] = record["share"]
			hash[:created_at] = format_time(record["created_at"])
			hash[:updated_at] = format_time(record["updated_at"])
			hash[:old_id] = record["id"]
			Record.create(hash)
		end
		if last_record_id.nil?
			p 'records完成'
		else
			p last_record_id
			cp_records(last_record_id)
		end
	end

	def cp_options
		@client.query("SELECT * FROM options order by id ASC").each do |option|
			hash = {}
			hash[:id] = option["id"]
			hash[:content] = option["content"]
			hash[:sequence] = option["sequence"]
			hash[:question_id] = option["question_id"]
			hash[:option_pic] = option["_option"]
			hash[:state] = option["state"]
			hash[:title] = option["title"]
			hash[:record_count] = option["record_count"]
			hash[:user_id] = option["user_id"]
			hash[:user_name] = option["user_name"]
			hash[:ip] = option["ip"]
			hash[:praise_count] = option["praise_count"]
			hash[:perfect] = option["perfect"]
			hash[:created_at] = format_time(option["created_at"])
			hash[:updated_at] = format_time(option["updated_at"])
			hash[:old_id] = option["id"]
			Option.create(hash)
		end	
		p 'options完成'
	end

	def cp_questions
		@client.query("SELECT * FROM questions order by id ASC").each do |question|
			paper = Paper.where(id: question["paper_id"]).first
			hash = {}
			hash[:id] = question["id"]
			hash[:content] = question["content"]
			hash[:genre] = question["genre"]
			hash[:sequence] = question["sequence"]
			hash[:reveal] = question["reveal"]
			hash[:post_id] = paper.blank? ? nil : paper.post_id
			hash[:option_count] = question["option_count"]
			hash[:question_pic] = question["_question"]
			hash[:state] = question["state"]
			hash[:created_at] = format_time(question["created_at"])
			hash[:updated_at] = format_time(question["updated_at"])
			hash[:old_id] = question["id"]
			Question.create(hash)
		end
		p "questions完成"
	end

	def cp_reports
		@client.query("SELECT * FROM reports order by id ASC").each do |report|
			hash = {}
			hash[:id] = report["id"]
			hash[:user_id] = report["user_id"]
			hash[:comment_id] = report["comment_id"]
			hash[:genre] = report["genre"]
			hash[:state] = report["state"]
			hash[:created_at] = format_time(report["created_at"])
			hash[:updated_at] = format_time(report["updated_at"])
			hash[:old_id] = report["id"]
			Report.create(hash)
		end
		p 'repost完成'
	end

	def cp_post_tags
		@client.query("SELECT * FROM article_tags order by id ASC").each do |article_tag|
			article = Article.where(id: article_tag["article_id"]).first
			
			hash = {}
			hash[:id] = article_tag["id"]
			hash[:post_id] = article.blank? ? nil : article.post_id
			hash[:tag_id] = article_tag["tag_id"]
			hash[:tag_genre] = article_tag["tag_genre"]
			hash[:created_at] = format_time(article_tag["created_at"])
			hash[:updated_at] = format_time(article_tag["updated_at"])
			hash[:old_id] = article_tag["id"]
			PostTag.create(hash)
		end
		p "post_tags完成"
	end

	def cp_post_relateds
		@client.query("SELECT * FROM article_relateds order by id ASC").each do |article_related|
			hash = {}
			ap = if !article_related["article_id"].blank?
				Article.where(id: article_related["article_id"]).first
			elsif !article_related["paper_id"].blank?
				Paper.where(id: article_related["paper_id"]).first
			end

			marn_article = Article.where(id: article_related["marn_article_id"]).first

			hash[:id] = article_related["id"]
			hash[:main_post_id] = marn_article.blank? ? nil : marn_article.post_id
			hash[:post_id] = ap.blank? ? nil : ap.post_id
			hash[:vote_id] = article_related["vote_id"]
			hash[:map_id] = article_related["map_id"]
			hash[:user_id] = article_related["user_id"]
			hash[:created_at] = format_time(article_related["created_at"])
			hash[:updated_at] = format_time(article_related["updated_at"])
			hash[:old_id] = article_related["id"]
			PostRelated.create(hash)
		end
		p 'article_relateds完成'
	end

	def cp_maps
		@client.query("SELECT * FROM maps order by id ASC").each do |map|
			article = Article.where(id: map["article_id"]).first
			post_id = unless article.blank?
				article.post_id
			else
				nil
			end
			hash = {}
			hash[:id] = map["id"]
			hash[:post_id] = post_id
			hash[:longitude] = map["longitude"]
			hash[:latitude] = map["latitude"]
			hash[:address] = map["address"]
			hash[:created_at] = format_time(map["created_at"])
			hash[:updated_at] = format_time(map["updated_at"])
			hash[:old_id] = map["id"]
			Map.create(hash)
		end
		p "maps完成"
	end

	def cp_company_titles
		@client.query("SELECT * FROM company_titles order by id ASC").each do |company_title|
			article = Article.where(id: company_title["article_id"]).first
		
			hash = {}
			hash[:id] = company_title["id"]
			hash[:post_id] = article.blank? ? nil : article.post_id
			hash[:title] = company_title["title"]
			hash[:excerpt] = company_title["excerpt"]
			hash[:genre] = company_title["genre"]
			hash[:created_at] = format_time(company_title["created_at"])
			hash[:updated_at] = format_time(company_title["updated_at"])
			hash[:old_id] = company_title["id"]
			CompanyTitle.create(hash)
		end
		p 'company_titles完成'
	end

	def cp_books
		@client.query("SELECT * FROM books order by id ASC").each do |book|
			article = Article.where(id: book["article_id"]).first

			hash = {}
			hash[:id] = book["id"]
			hash[:title] = book["title"]
			hash[:description] = book["description"]
			hash[:author] = book["author"]
			hash[:publishers] = book["publishers"]
			hash[:publication_date] = book["publication_date"]
			hash[:book_cover_pic] = book["_book_cover"]
			hash[:url] = book["url"]
			hash[:post_id] = article.blank? ? nil : article.post_id
			hash[:created_at] = format_time(book["created_at"])
			hash[:updated_at] = format_time(book["updated_at"])
			hash[:old_id] = book["id"]	
			Book.create(hash)
		end
		p 'books完成'
	end	

	def cp_articles_and_posts
		log = File.open(File.join(@path , "article_and_posts.log") , 'a')
		aps = @client.query("SELECT * FROM (SELECT id , 'article' AS datatype , publish_time FROM articles UNION ALL SELECT id , 'paper' AS datatype , publish_time from papers) AS ap ORDER BY publish_time ASC , id ASC")
		aps.each do |ap|
			if ap["datatype"].eql?("article")
				begin
					article = @client.query("SELECT  `articles`.* FROM `articles` WHERE `articles`.`id` = #{ap["id"]} LIMIT 1").to_a[0]
					Article.transaction do
						post_hash = {}
						post_hash[:status] = article["status"]
						post_hash[:publish_time] = format_time(article["publish_time"])
						post_hash[:comment_count] = article["comment_count"]
						post_hash[:praise_count] = article["praise_count"]
						post_hash[:record_count] = article["record_count"]
						post_hash[:front] = article["front"]
						post_hash[:parent_id] = article["parent_id"]
						post_hash[:genre] = article["genre"]
						post_hash[:category_id] = article["category_id"]
						post_hash[:user_id] = article["user_id"]
						post_hash[:length] = article["length"]
						post_hash[:image_format] = article["image_format"]
						post_hash[:state] = article["state"]
						post_hash[:cover_id] = article["cover_id"]
						post_hash[:title_reveal] = article["title_reveal"]
						post_hash[:feedback_url] = article["feedback_url"]
						post_hash[:special_column_id] = article["special_column_id"]
						post_hash[:reveal] = article["reveal"]
						post_hash[:position] = article["position"]
						post_hash[:created_at] = format_time(article["created_at"])
						post_hash[:updated_at] = format_time(article["updated_at"])
						post_hash[:datatype] = 'article'
						post_hash[:old_id] = article["id"]
						post = Post.create!(post_hash)



						article_hash = {}
						article_hash[:id] = article["id"]
						article_hash[:post_id] = post.id
						article_hash[:title] = article["title"]
						article_hash[:subtitle] = article["subtitle"]
						article_hash[:excerpt] = article["excerpt"]
						article_hash[:content] = article["new_content"]
						article_hash[:comment_status] = article["comment_status"]
						article_hash[:sequence] = article["sequence"]
						article_hash[:author] = article["author"]
						article_hash[:banner_pic] = article["_banner"]
						article_hash[:article_index_pic] = article["article_index"]
						article_hash[:article_show_pic] = article["article_show"]
						article_hash[:super_tag] = article["super_tag"]
						article_hash[:length] = article["length"]
						article_hash[:long_show_pic] = article["long_show"]
						article_hash[:annotation] = article["annotation"]
						article_hash[:top15] = article["top15"]
						article_hash[:classification] = article["classification"]
						article_hash[:path] = article["path"]
						article_hash[:start_date] = format_time(article["start_date"])
						article_hash[:end_date] = format_time(article["end_date"])
						article_hash[:created_at] = format_time(article["created_at"])
						article_hash[:updated_at] = format_time(article["updated_at"])
						article_hash[:old_id] = article["id"] 
						Article.create!(article_hash)
					end
				rescue => e
					log.write("article=>原id为#{article["id"]}")
				end
			elsif ap["datatype"].eql?("paper")
				begin
					paper = @client.query("SELECT  `papers`.* FROM `papers` WHERE `papers`.`id` = #{ap["id"]} LIMIT 1").to_a[0]
					Paper.transaction do
						post_hash = {}
						post_hash[:status] = paper["status"]
						post_hash[:publish_time] = paper["publish_time"]
						post_hash[:comment_count] = paper["comment_count"]
						post_hash[:praise_count] = paper["praise_count"]
						post_hash[:record_count] = paper["record_count"]
						post_hash[:front] = paper["front"]
						post_hash[:parent_id] = paper["parent_id"]
						post_hash[:genre] = paper["genre"]
						post_hash[:category_id] = paper["category_id"]
						post_hash[:user_id] = paper["user_id"]
						post_hash[:length] = paper["length"]
						post_hash[:image_format] = paper["image_format"]
						post_hash[:state] = paper["state"]
						post_hash[:cover_id] = paper["cover_id"]
						post_hash[:title_reveal] = paper["title_reveal"]
						post_hash[:feedback_url] = paper["feedback_url"]
						post_hash[:special_column_id] = paper["special_column_id"]
						post_hash[:reveal] = paper["reveal"]
						post_hash[:position] = paper["position"]
						post_hash[:created_at] = format_time(paper["created_at"])
						post_hash[:updated_at] = format_time(paper["updated_at"])
						post_hash[:datatype] = 'paper'
						post_hash[:old_id] = paper["id"]
						post = Post.create!(post_hash)
						
						paper_hash = {}
						paper_hash[:id] = paper["id"]
						paper_hash[:post_id] = post.id
						paper_hash[:title] = paper["title"]
						paper_hash[:description] = paper["description"]
						paper_hash[:sequence] = paper["sequence"]
						paper_hash[:paper_index_pic] = paper["paper_index"]
						paper_hash[:paper_show_pic] = paper["paper_show"]
						paper_hash[:comment_status] = paper["comment_status"]
						paper_hash[:author] = paper["author"]
						paper_hash[:created_at] = format_time(paper["created_at"])
						paper_hash[:updated_at] = format_time(paper["updated_at"])
						paper_hash[:old_id] = paper["id"]
						Paper.create!(paper_hash)
					end
				rescue => e
					log.write("paper=>原id为#{paper["id"]}")
				end
			end
		end
		p 'article paper post 已完成'
	end

	def cp_users(id = nil)
		users = if id.nil?
			@client.query("SELECT * FROM users order by id ASC limit 10000")
		else
			@client.query("SELECT * FROM users where id > #{id} order by id ASC limit 10000")
		end
		last_user_id = nil
		users.each do |user|
			last_user_id = user["id"]
			hash = {}
			hash[:id] = user["id"]
			hash[:username] = user["username"]
			hash[:profile_id] = user["profile_id"]
			hash[:face_pic] = user["_face"]
			hash[:background_image_pic] = user["_background_image"]
			hash[:_alias] = user["_alias"]
			hash[:comments_push_switch] = user["comments_push_switch"]
			hash[:praises_push_switch] = user["praises_push_switch"]
			hash[:letter_push_switch] = user["letter_push_switch"]
			hash[:phone] = user["phone"]
			hash[:description] = user["description"]
			hash[:private_token] = user["private_token"]
			hash[:weibo_uid] = user["weibo_uid"]
			hash[:qq_uid] = user["qq_uid"]
			hash[:wechat_uid] = user["wechat_uid"]
			hash[:twitter_uid] = user["twitter_uid"]
			hash[:message_count] = user["message_count"]
			hash[:source] = user["source"]
			hash[:letter_count] = user["letter_count"]
			hash[:phone_verify] = user["phone_verify"]
			hash[:address] = user["address"]
			hash[:email] = user["email"]
			hash[:encrypted_password] = user["encrypted_password"]
			hash[:reset_password_token] = user["reset_password_token"]
			hash[:reset_password_sent_at] = format_time(user["reset_password_sent_at"])
			hash[:remember_created_at] = format_time(user["remember_created_at"])
			hash[:sign_in_count] = user["sign_in_count"]
			hash[:current_sign_in_at] = format_time(user["current_sign_in_at"])
			hash[:last_sign_in_at] = format_time(user["last_sign_in_at"])
			hash[:current_sign_in_ip] = user["current_sign_in_ip"]
			hash[:last_sign_in_ip] = user["last_sign_in_ip"]
			hash[:confirmation_token] = user["confirmation_token"]
			hash[:confirmed_at] = format_time(user["confirmed_at"])
			hash[:confirmation_sent_at] = format_time(user["confirmation_sent_at"])
			hash[:unconfirmed_email] = user["unconfirmed_email"]
			hash[:created_at] = format_time(user["created_at"])
			hash[:updated_at] = format_time(user["updated_at"])
			hash[:old_id] = user["id"]
			User.create!(hash)
		end
		if last_user_id.nil?
			p 'users完成'
		else
			p last_user_id
			cp_users(last_user_id)
		end
	end

	def cp_touch_icons
		@client.query("SELECT * FROM touch_icons order by id ASC").each do |touch_icon|
			hash = {}
			hash[:id] = touch_icon["id"]
			hash[:title] = touch_icon["title"]
			hash[:genre] = touch_icon["genre"]
			hash[:url] = touch_icon["url"]
			hash[:state] = touch_icon["state"]
			hash[:sequence] = touch_icon["sequence"]
			hash[:created_at] = format_time(touch_icon["created_at"])
			hash[:updated_at] = format_time(touch_icon["updated_at"])
			hash[:old_id] = touch_icon["id"]
			TouchIcon.create(hash)
		end
		p "touch_icons完成"
	end

	def cp_tags
		@client.query("SELECT * FROM tags order by id ASC").each do |tag|
			hash = {}
			hash[:id] = tag["id"]
			hash[:title] = tag["title"]
			hash[:state] = tag["state"]
			hash[:created_at] = format_time(tag["created_at"])
			hash[:updated_at] = format_time(tag["updated_at"])
			hash[:old_id] = tag["id"]
			Tag.create(hash)
		end
		p 'tags完成'
	end

	def cp_systems
		@client.query("SELECT * FROM systems order by id ASC").each do |system|
			hash = {}
			hash[:id] = system["id"]
			hash[:download] = system["download"]
			hash[:weibo_token] = system["weibo_token"]
			hash[:created_at] = format_time(system["created_at"])
			hash[:updated_at] = format_time(system["updated_at"])
			hash[:old_id] = system["id"]
			System.create(hash)
		end
		p 'systems完成'
	end

	def cp_subscribes
		@client.query("SELECT * FROM subscribes order by id ASC").each do |subscribe|
			hash = {}
			hash[:id] = subscribe["id"]
			hash[:special_column_id] = subscribe["special_column_id"]
			hash[:user_id] = subscribe["user_id"]
			hash[:created_at] = format_time(subscribe["created_at"])
			hash[:updated_at] = format_time(subscribe["updated_at"])
			hash[:old_id] = subscribe['id']
			Subscribe.create(hash)
		end
		p "subscribes完成"
	end

	def cp_special_columns
		@client.query("SELECT * FROM special_columns order by id ASC").each do |special_column|
			article = Article.where(id: special_column["article_id"]).first

			hash = {}
			hash[:id] = special_column["id"]
			hash[:title] = special_column["title"]
			hash[:genre] = special_column["genre"]
			hash[:excerpt] = special_column["excerpt"]
			hash[:subscriber_num] = special_column["subscriber_num"]
			hash[:post_count] = special_column["post_count"]
			hash[:state] = special_column["state"]
			hash[:reveal] = special_column["reveal"]
			hash[:post_id] = article.blank? ? nil : article.post_id
			hash[:column_pic] = special_column["_column"]
			hash[:icon_pic] = special_column["_icon"]
			hash[:sort_time] = format_time(special_column["sort_time"])
			hash[:column_show_pic] = special_column["_column_show"]
			hash[:author_reveal] = special_column["author_reveal"]
			hash[:subscribe_status] = special_column["subscribe_status"]
			hash[:content_provider] = special_column["content_provider"]
			hash[:created_at] = format_time(special_column["created_at"])
			hash[:updated_at] = format_time(special_column["updated_at"])
			hash[:old_id] = special_column["id"]
			SpecialColumn.create(hash)
		end
		p 'special_columns完成'
	end

	def cp_radars(id = nil)
		radars = if id.nil?
			@client.query("SELECT * FROM radars order by id ASC limit 10000")
		else
			@client.query("SELECT * FROM radars where id > #{id} order by id ASC limit 10000")
		end
		last_radar_id = nil
		radars.each do |radar|
			last_radar_id = radar["id"]
			hash = {}
			hash[:id] = radar["id"]
			hash[:user_id] = radar["user_id"]
			hash[:total_one] = radar["total_one"]
			hash[:total_two] = radar["total_two"]
			hash[:total_three] = radar["total_three"]
			hash[:total_four] = radar["total_four"]
			hash[:total_five] = radar["total_five"]
			hash[:ratio_one] = radar["ratio_one"]
			hash[:ratio_two] = radar["ratio_two"]
			hash[:ratio_three] = radar["ratio_three"]
			hash[:ratio_four] = radar["ratio_four"]
			hash[:ratio_five] = radar["ratio_five"]
			hash[:created_at] = format_time(radar["created_at"])
			hash[:updated_at] = format_time(radar["updated_at"])
			hash[:old_id] = radar['id']
			Radar.create(hash)
		end
		if last_radar_id.nil?
			p 'radars完成'	
		else
			p last_radar_id
			cp_radars(last_radar_id)
		end
		
	end

	def cp_partners
		@client.query("SELECT * FROM partners order by id ASC").each do |partner|
			hash = {}
			hash[:id] = partner["id"]
			hash[:title] = partner["title"]
			hash[:description] = partner["description"]
			hash[:face_pic] = partner["_face"]
			hash[:sequence] = partner["sequence"]
			hash[:state] = partner["state"]
			hash[:created_at] = format_time(partner["created_at"])
			hash[:updated_at] = format_time(partner["updated_at"])
			hash[:old_id] = partner["id"]
			Partner.create(hash)
		end
		p 'partners完成'
	end

	def cp_paper_categories
		@client.query("SELECT * FROM paper_categories order by id ASC").each do |paper_category|
			hash = {}
			hash[:id] = paper_category["id"]
			hash[:title] = paper_category["title"]
			hash[:description] = paper_category["description"]
			hash[:url] = paper_category["url"]
			hash[:state] = paper_category["state"]
			hash[:icon_white_pic] = paper_category["icon_white"]
			hash[:created_at] = format_time(paper_category["created_at"])
			hash[:updated_at] = format_time(paper_category["updated_at"])
			hash[:old_id] = paper_category["id"]
			PaperCategory.create(hash)
		end
		p 'paper_categories完成'
	end

	def cp_mount_details
		@client.query("SELECT * FROM mount_details order by id ASC").each do |mount_detail|
			hash = {}
			hash[:id] = mount_detail["id"]
			hash[:title] = mount_detail["title"]
			hash[:description] = mount_detail["description"]
			hash[:sequence] = mount_detail["sequence"]
			hash[:url] = mount_detail["url"]
			hash[:state] = mount_detail["state"]
			hash[:banner_pic] = mount_detail["_banner"]
			hash[:genre] = mount_detail["genre"]
			hash[:position] = mount_detail["position"]
			hash[:category_id] = mount_detail["category_id"]
			hash[:start_date] = format_time(mount_detail["start_date"])
			hash[:end_date] = format_time(mount_detail["end_date"])
			hash[:feedback_url] = mount_detail["feedback_url"]
			hash[:created_at] = format_time(mount_detail["created_at"])
			hash[:updated_at] = format_time(mount_detail["updated_at"])
			hash[:old_id] = mount_detail["id"]
			MountDetail.create(hash)
		end
		p 'mount_details完成'
	end

	def cp_filters
		@client.query("SELECT * FROM filters order by id ASC").each do |filter|
			hash = {}
			hash[:id] = filter["id"]
			hash[:ip] = filter["ip"]
			hash[:keyword] = filter["keyword"]
			hash[:regex] = filter["regex"]
			hash[:created_at] = format_time(filter["created_at"])
			hash[:updated_at] = format_time(filter["updated_at"])
			hash[:old_id] = filter["id"]
			Filter.create(hash)
		end
		p "filters完成"
	end

	def cp_feedbacks
		@client.query("SELECT * FROM feedbacks order by id ASC").each do |feedback|
			hash = {}
			hash[:id] = feedback["id"]
			hash[:title] = feedback["title"]
			hash[:content] = feedback["content"]
			hash[:user_id] = feedback["user_id"]
			hash[:state] = feedback["state"]
			hash[:machine_type] = feedback["machine_type"]
			hash[:machine_parameters] = feedback["machine_parameters"]
			hash[:email] = feedback["email"]
			hash[:created_at] = format_time(feedback["created_at"])
			hash[:updated_at] = format_time(feedback["updated_at"])
			hash[:old_id] = feedback["id"]
			Feedback.create(hash)
		end
		p 'feedbacks完成'
	end

	def cp_faces
		@client.query("SELECT * FROM faces order by id ASC").each do |face|
			hash = {}
			hash[:id] = face["id"]
			hash[:title] = face["title"]
			hash[:description] = face["description"]
			hash[:face_pic] = face["_face"]
			hash[:sequence] = face["sequence"]
			hash[:state] = face["state"]
			hash[:created_at] = format_time(face["created_at"])
			hash[:updated_at] = format_time(face["updated_at"])
			hash[:old_id] = face["id"]
			Face.create(hash)
		end
		p 'faces完成'
	end

	def cp_downloads
		@client.query("SELECT * FROM downloads order by id ASC").each do |download|
			hash = {}
			hash[:id] = download["id"]
			hash[:title] = download["title"]
			hash[:description] = download["description"]
			hash[:ios_url] = download["ios_url"]
			hash[:android_url] = download["android_url"]
			hash[:state] = download["state"]
			hash[:created_at] = format_time(download["created_at"])
			hash[:updated_at] = format_time(download["updated_at"])
			hash[:old_id] = download["id"]
			Download.create(hash)
		end
		p 'downloads完成'
	end

	def cp_curiosities
		@client.query("SELECT * FROM curiosities order by id ASC").each do |curiosity|
			hash = {}
			hash[:id] = curiosity["id"]
			hash[:title] = curiosity["title"]
			hash[:sequence] = curiosity["sequence"]
			hash[:description] = curiosity["description"]
			hash[:state] = curiosity["state"]
			hash[:excerpt] = curiosity["excerpt"]
			hash[:created_at] = format_time(curiosity["created_at"])
			hash[:updated_at] = format_time(curiosity["updated_at"])
			hash[:old_id] = curiosity["id"]
			Curiosity.create(hash)
		end
		p "curiosities完成"
	end

	def cp_covers
		@client.query("SELECT * FROM covers order by id ASC").each do |cover|
			hash = {}
			hash[:id] = cover["id"]
			hash[:title] = cover["title"]
			hash[:genre] = cover["genre"]
			hash[:cover_pic] = cover["_cover"]
			hash[:state] = cover["state"]
			hash[:created_at] = format_time(cover["created_at"])
			hash[:updated_at] = format_time(cover["updated_at"])
			hash[:old_id] = cover["id"]
			Cover.create(hash)
		end
		p 'covers完成'
	end

	def cp_columnists
		@client.query("SELECT * FROM columnists order by id ASC").each do |columnist|
			hash = {}
			hash[:id] = columnist["id"]
			hash[:user_id] = columnist["user_id"]
			hash[:special_column_id] = columnist["special_column_id"]
			hash[:created_at] = format_time(columnist["created_at"])
			hash[:updated_at] = format_time(columnist["updated_at"])
			hash[:old_id] = columnist["id"]
			Columnist.create(hash)
		end
		p 'columnists完成'
	end
		

	def cp_categories
		@client.query("SELECT * FROM categories order by id ASC").each do |category|
			article = begin
				Article.find(category["recent_article_id"])
			rescue
				nil
			end
			recent_post_id = unless article.blank?
				article.post_id	
			else
				nil
			end

			hash = {}
			hash[:id] = category["id"]
			hash[:title] = category["title"]
			hash[:description] = category["description"]
			hash[:url] = category["url"]
			hash[:sequence] = category["sequence"]
			hash[:reveal] = category["reveal"]
			hash[:status] = category["status"]
			hash[:parent_id] = category["parent_id"]
			hash[:article_count] = category["article_count"]
			hash[:icon_white_pic] = category["icon_white"]
			hash[:icon_black_pic] = category["icon_black"]
			hash[:state] = category["state"]
			hash[:genre] = category["genre"]
			hash[:icon_app_pic] = category["icon_app"]
			hash[:recent_post_id] = recent_post_id
			hash[:front] = category["front"]
			hash[:icon_black_app_pic] = category["icon_black_app"]
			hash[:icon_white_app_pic] = category["icon_white_app"]
			hash[:tag_id] = category["tag_id"]
			hash[:icon_yellow_app_pic] = category["icon_yellow_app"]
			hash[:icon_black_pad_pic] = category["icon_black_pad"]
			hash[:created_at] = format_time(category["created_at"])
			hash[:updated_at] = format_time(category["updated_at"])
			hash[:old_id] = category["id"]
			Category.create(hash)
		end
		p 'categories完成'
	end

	def cp_boot_advertisements
		@client.query("SELECT * FROM boot_advertisements order by id ASC").each do |boot_advertisement|
			hash = {}
			hash[:id] = boot_advertisement["id"]
			hash[:title] = boot_advertisement["title"]
			hash[:start_date] = format_time(boot_advertisement["start_date"])
			hash[:end_date] = format_time(boot_advertisement["end_date"])
			hash[:genre] = boot_advertisement["genre"]
			hash[:h5_url] = boot_advertisement["h5_url"]
			hash[:state] = boot_advertisement["state"]
			hash[:status] = boot_advertisement["status"]
			hash[:total_seconds] = boot_advertisement["total_seconds"]
			hash[:ad_type] = boot_advertisement["ad_type"]
			hash[:redirect_url] = boot_advertisement["redirect_url"]
			hash[:feedback_url] = boot_advertisement["feedback_url"]
			hash[:zip_ip4_file_name] = boot_advertisement["zip_ip4_file_name"]
			hash[:zip_ip4_content_type] = boot_advertisement["zip_ip4_content_type"]
			hash[:zip_ip4_file_size] = boot_advertisement["zip_ip4_file_size"]
			hash[:zip_ip4_updated_at] = boot_advertisement["zip_ip4_updated_at"]
			hash[:zip_ip5_file_name] = boot_advertisement["zip_ip5_file_name"]
			hash[:zip_ip5_content_type] = boot_advertisement["zip_ip5_content_type"]
			hash[:zip_ip5_file_size] = boot_advertisement["zip_ip5_file_size"]
			hash[:zip_ip5_updated_at] = boot_advertisement["zip_ip5_updated_at"]
			hash[:zip_ip6_file_name] = boot_advertisement["zip_ip6_file_name"]
			hash[:zip_ip6_content_type] = boot_advertisement["zip_ip6_content_type"]
			hash[:zip_ip6_file_size] = boot_advertisement["zip_ip6_file_size"]
			hash[:zip_ip6_updated_at] = boot_advertisement["zip_ip6_updated_at"]
			hash[:zip_ip6p_file_name] = boot_advertisement["zip_ip6p_file_name"]
			hash[:zip_ip6p_content_type] = boot_advertisement["zip_ip6p_content_type"]
			hash[:zip_ip6p_file_size] = boot_advertisement["zip_ip6p_file_size"]
			hash[:zip_ip6p_updated_at] = boot_advertisement["zip_ip6p_updated_at"]
			hash[:zip_480_small_file_name] = boot_advertisement["zip_480_small_file_name"]
			hash[:zip_480_small_content_type] = boot_advertisement["zip_480_small_content_type"]
			hash[:zip_480_small_file_size] = boot_advertisement["zip_480_small_file_size"]
			hash[:zip_480_small_updated_at] = boot_advertisement["zip_480_small_updated_at"]
			hash[:zip_720_small_file_name] = boot_advertisement["zip_720_small_file_name"]
			hash[:zip_720_small_content_type] = boot_advertisement["zip_720_small_content_type"]
			hash[:zip_720_small_file_size] = boot_advertisement["zip_720_small_file_size"]
			hash[:zip_720_small_updated_at] = boot_advertisement["zip_720_small_updated_at"]
			hash[:zip_1080_small_file_name] = boot_advertisement["zip_1080_small_file_name"]
			hash[:zip_1080_small_content_type] = boot_advertisement["zip_1080_small_content_type"]
			hash[:zip_1080_small_file_size] = boot_advertisement["zip_1080_small_file_size"]
			hash[:zip_1080_small_updated_at] = boot_advertisement["zip_1080_small_updated_at"]
			hash[:zip_ipad_file_name] = boot_advertisement["zip_ipad_file_name"]
			hash[:zip_ipad_content_type] = boot_advertisement["zip_ipad_content_type"]
			hash[:zip_ipad_file_size] = boot_advertisement["zip_ipad_file_size"]
			hash[:zip_ipad_updated_at] = boot_advertisement["zip_ipad_updated_at"]
			hash[:zip_1920_small_file_name] = boot_advertisement["zip_1920_small_file_name"]
			hash[:zip_1920_small_content_type] = boot_advertisement["zip_1920_small_content_type"]
			hash[:zip_1920_small_file_size] = boot_advertisement["zip_1920_small_file_size"]
			hash[:zip_1920_small_updated_at] = boot_advertisement["zip_1920_small_updated_at"]
			hash[:created_at] = format_time(boot_advertisement["created_at"])
			hash[:updated_at] = format_time(boot_advertisement["updated_at"])
			hash[:old_id] = boot_advertisement["id"]
			BootAdvertisement.create(hash)
		end
		p 'boot_advertisements完成'
	end

	def cp_apks
		@client.query("SELECT * FROM apks order by id ASC").each do |apk|
			hash = {}
			hash[:id] = apk["id"]
			hash[:title] = apk["title"]
			hash[:excerpt] = apk["excerpt"]
			hash[:content] = apk["content"]
			hash[:version] = apk["version"]
			hash[:file] = apk["file"]
			hash[:state] = apk["state"]
			hash[:created_at] = format_time(apk["created_at"])
			hash[:updated_at] = format_time(apk["updated_at"])
			hash[:old_id] = apk["id"]
			Apk.create(hash)
		end
		p 'apks完成'
	end

	def cp_activities
		@client.query("SELECT * FROM activities order by id ASC").each do |activity|
			hash = {}
			hash[:id] = activity["id"]
			hash[:title] = activity["title"]
			hash[:description] = activity["description"]
			hash[:content] = activity["content"]
			hash[:url] = activity["url"]
			hash[:banner_pic] = activity["_banner"]
			hash[:begin_time] = format_time(activity["begin_time"])
			hash[:end_time] = format_time(activity["end_time"])
			hash[:code_file] = activity["code_file"]
			hash[:code_count] = activity["code_count"]
			hash[:created_at] = format_time(activity["created_at"])
			hash[:updated_at] = format_time(activity["created_at"])
			hash[:old_id] = activity["id"]
			Activity.create(hash)
		end
		p 'activities完成'
	end	

	def format_time(time)
		time = (time + (60 * 60 * 8)) unless time.nil?
		return time
	end
end
DataTransfer.new.start
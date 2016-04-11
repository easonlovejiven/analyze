# coding: utf-8
class Admin::DocumentsController < Admin::BaseController

  def index
  end

  def more_document
    @search = params[:search][:value] ? params[:search][:value] : ""
    @per_page = params[:per_page] ? params[:per_page] : 10
    page = params[:page] || 1
    start = params[:start].to_i || 0
    length = params[:length] ? params[:length].to_i : 10
    page = (start / length) + 1;
    @per_page = length;
    documents = Document.where(["file_file_name like ?", "%%#{@search}%%"]).paginate(page: page , per_page: @per_page).order("id DESC")
    data = documents.collect { |item| {:id => item.id, :file_file_name => item.file_file_name, :file_content_type => item.file_content_type, :file_file_size => item.file_file_size,  :file_updated_at => item.file_updated_at.to_date, :file_state => item.show_file_state } }
    has_more = (documents.length == 0 ? false : true)
    all_count = documents.count
    draw = params[:draw].to_i + 1
    render :json => {:draw => draw, :has_more => has_more, :start => start, :recordsTotal => all_count, :recordsFiltered => all_count, :data => data }
  end

  def new
    @document = Document.new
  end

  def create
    sum = Api::V1::SumMessagesController.new
    @document = Document.new(document_params)
    if @document.save
      sum.read_file
      redirect_to admin_documents_url, notice: '新建成功！'
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to admin_documents_url
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end
end
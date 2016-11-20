class AlLinksController < ApplicationController

  def new
    @link = AlLink.new
  end

  def create
    @link = AlLink.new(link_params)

    respond_to do |format|
      if @link.save
        format.html do
          RedmineAutoLinker::AutoLinker.reload
          flash[:notice] = l(:notice_successful_create)
          redirect_to '/settings/plugin/redmine_autolinker'
        end
      else
        format.html { render :action => 'new' }
      end
    end
  end

  def update
    @link = AlLink.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(link_params)
        format.html do
          RedmineAutoLinker::AutoLinker.reload
          flash[:notice] = l(:notice_successful_update)
          redirect_to '/settings/plugin/redmine_autolinker'
        end
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  def destroy
    @link = AlLink.find(params[:id])
    @link.destroy()

    respond_to do |format|
      RedmineAutoLinker::AutoLinker.reload
      format.html { redirect_to '/settings/plugin/redmine_autolinker' }
    end
  end

  def edit
    @link = AlLink.find(params[:id])
  end

  private

  def link_params
    params.require(:al_link).permit(:expression, :url_template)
  end
end

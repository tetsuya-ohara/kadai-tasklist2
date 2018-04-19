class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :show, :edit, :update]
  
  def index
    @tasks = current_user.tasks.all
  end

  def show
   @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Taskを正常に作成しました。'
      redirect_to root_url
    else
      @task = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Taskが正常に作成されませんでした。'
      render 'toppages/index'
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update

    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました。'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした。'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Taskは正常に削除されました。'
    redirect_back(fallback_location: root_path)
  end
  
  
  private
  
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end

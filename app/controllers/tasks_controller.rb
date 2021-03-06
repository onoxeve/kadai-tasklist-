class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Taskを作成しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Taskの作成に失敗しました。'
      render 'toppages/index'
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:succcess] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskの更新に失敗しました'
      render :edit
    end
  end
  
  def show
  end

  def destroy
    @task.destroy
    flash[:success] = 'Taskを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_path
    end
  end
end
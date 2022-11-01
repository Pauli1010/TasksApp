# frozen_string_literal: true

class TasksController < ApplicationController
  helper_method :tasks, :task

  def index; end

  def show; end

  def new
    @form = TaskForm.new
  end

  def create
    @form = TaskForm.from_params(params)

    CreateTask.call(@form, current_user) do
      on(:ok)      { redirect_to tasks_path, notice: t('tasks.create.success') }
      on(:invalid) { render :new, alert: t('tasks.create.error') }
    end
  end

  def edit
    @form = TaskForm.from_model(task)
  end

  def update
    @form = TaskForm.from_params(params)

    UpdateTask.call(@form, task, current_user) do
      on(:ok)      { redirect_to tasks_path, notice: t('tasks.update.success') }
      on(:invalid) { render :edit, alert: t('tasks.update.error') }
    end
  end

  private

  def tasks
    @tasks ||= current_user.tasks
  end

  def task
    @task ||= tasks.find_by(id: params[:id])
  end
end

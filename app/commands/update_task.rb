# frozen_string_literal: true

class UpdateTask < Rectify::Command
  def initialize(form, task, current_user)
    @form = form
    @task = task
    @user = current_user
  end

  def call
    return broadcast(:invalid) if form.invalid?

    transaction do
      update_task
    end

    broadcast(:ok, task)
  end

  private

  attr_reader :form, :user, :task

  def update_task
    task.update(task_attributes)
  end

  def task_attributes
    {
      title: form.title,
      due_time: form.due_time,
      highlited: form.highlited,
      note: form.note
    }
  end
end
# frozen_string_literal: true

class CreateTask < Rectify::Command
  def initialize(form, current_user)
    @form = form
    @user = current_user
  end

  def call
    return broadcast(:invalid) if form.invalid?

    transaction do
      create_task
    end

    broadcast(:ok, task)
  end

  private

  attr_reader :form, :user, :task

  def create_task
    @task = Task.create(task_attributes)
  end

  def task_attributes
    {
      user: user,
      title: form.title,
      due_time: form.due_time,
      highlited: form.highlited,
      note: form.note
    }
  end
end
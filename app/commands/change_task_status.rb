# frozen_string_literal: true

class ChangeTaskStatus < Rectify::Command
  def initialize(task_status, task, current_user)
    @task_status = task_status
    @task = task
    @user = current_user
  end

  def call
    return broadcast(:invalid) unless Task.statuses[task_status]

    transaction do
      set_done_time
      task.send("#{task_status}!")
    end

    broadcast(:ok, task)
  end

  private

  attr_reader :task_status, :task, :user

  def set_done_time
    task.update(done_time: task_status == Task.statuses['done'] ? Time.current : '')
  end
end
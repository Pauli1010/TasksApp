# frozen_string_literal: true

class DeleteTask < Rectify::Command
  def initialize(task, current_user)
    @task = task
    @user = current_user
  end

  def call
    return broadcast(:invalid) if task.user != user

    transaction do
      destroy_task
    end

    broadcast(:ok)
  end

  private

  attr_reader :user, :task

  def destroy_task
    task.destroy!
  end
end
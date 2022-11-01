# frozen_string_literal: true

class TaskForm < Rectify::Form
  mimic :task

  attribute :title, String
  attribute :due_time, DateTime
  attribute :note, String
  attribute :highlited, Boolean

  validates :title, :due_time, presence: true
  validate :due_time_in_future

  def due_time_in_future
    errors.add(:due_time, t('.must_be_in_the_future')) unless due_time.future?
  end
end
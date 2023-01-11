# frozen_string_literal: true

class TaskForm < Rectify::Form
  include ActionView::Helpers::TranslationHelper
  mimic :task

  attribute :title, String
  attribute :due_time, DateTime
  attribute :note, String
  attribute :highlited, Boolean

  validates :title, :due_time, presence: true
  validate :due_time_in_future

  def due_time_in_future
    return unless due_time.present?

    errors.add(:due_time, t('must_be_in_the_future', scope: 'errors.due_time')) unless due_time.to_datetime.future?
  end
end
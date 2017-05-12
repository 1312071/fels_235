class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true

  enum action: {follow: 1, unfollow: 2, start_lesson: 3, finish_lesson: 4}
  scope :user_activity, ->user_id {where("user_id = ?", user_id)
    .order(created_at: :DESC)}

  def target_object
    case action_type
    when Activity.actions[:follow]
      User.find_by id: target_id
    when Activity.actions[:unfollow]
      User.find_by id: target_id
    when Activity.actions[:start_lesson]
      Lesson.find_by id: target_id
    when Activity.actions[:finish_lesson]
      Lesson.find_by id: target_id
    end
  end
end

# Facilitator role
class Facilitator < ActiveRecord::Base
  include ModelHelper
  belongs_to :user
  before_validation :fill_current_cohort
  validates :user_id, presence: true, uniqueness: {
    scope: :cohort,
    message: 'can only have one facilitator role for each cohort'
  }

  def Facilitator.sort(sort_by)
    case sort_by
    when 'name'
      Facilitator.where(
        cohort: 2020
      ).joins(:user).order(user_id: :asc)
    when 'oldest'
      Facilitator.where(
        cohort: 2020
      ).joins(:user).order(created_at: :asc)
    when 'newest'
      Facilitator.where(
        cohort: 2020
      ).joins(:user).order(created_at: :desc)
    when 'display_order'
      Facilitator.where(
        cohort: 2020
      ).joins(:user).order(display_order: :asc)
    end
  end
end

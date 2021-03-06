# Facilitator role
class Facilitator < ActiveRecord::Base
  include ModelHelper
  belongs_to :user
  before_validation :fill_current_cohort
  validates :user_id, presence: true, uniqueness: {
    scope: :cohort,
    message: 'can only have one facilitator role for each cohort'
  }

  def Facilitator.sort(sort_by, cohort)
    case sort_by
    when 'name'
      Facilitator.where(
        cohort: cohort
      ).joins(:user).order('user_name')
    when 'display_order'
      Facilitator.where(
        cohort: cohort
      ).joins(:user).order('display_order ASC, user_name')
    end
  end
end

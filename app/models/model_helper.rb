# collection of helper methods for models
module ModelHelper
  def current_cohort
    Time.now.year
  end

  def fill_current_cohort
    self.cohort = current_cohort if cohort.blank?
  end
end

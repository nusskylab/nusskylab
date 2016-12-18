# Collection of helper methods related to cohort
module CohortHelper
  def current_cohort
    Time.now.year
  end

  def all_cohorts
    [2016, 2015, 2014, 2013]
  end
end

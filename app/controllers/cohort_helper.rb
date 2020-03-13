# Collection of helper methods related to cohort
module CohortHelper
  def current_cohort
    Time.now.year
  end

  def all_cohorts
    arr = []
    for year in 2013 .. current_cohort do
      arr.push(year)
    end
    return arr.reverse()
  end
end

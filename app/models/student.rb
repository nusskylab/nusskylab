# Student: student modeling
class Student < ActiveRecord::Base
  include ModelHelper
  validates :user_id, presence: true, uniqueness: {
    scope: :cohort,
    message: 'can have only one student role for each cohort'
  }
  before_validation :fill_current_cohort

  belongs_to :user
  belongs_to :team, dependent: :destroy

  def self.student?(user_id, extra = nil)
    if extra
      extra[:user_id] = user_id
      Student.find_by(extra)
    else
      Student.find_by(user_id: user_id)
    end
  end

  def self.to_csv(**options)
    require 'csv'
    if options[:cohort].nil?
      exported_stus = all
    else
      exported_stus = where(cohort: options[:cohort])
      options.delete(:cohort)
    end
    CSV.generate(options) do |csv|
      csv << generate_csv_header_row
      exported_stus.each do |student|
        csv_row = [student.user.user_name, student.user.id, student.user.email]
        csv_row.concat(student.team_adviser_info)
        if student.team
          csv_row.concat([student.team.id])
        else
          csv_row.concat(['No Team'])
        end
        if student.evaluatee_ids
          evaluated_links = []
          student.evaluatee_ids.each do |teamID|
            team = Team.find_by(id: teamID)
            evaluated_links << team.proposal_link
          end
          csv_row.concat([student.evaluatee_ids.join(', '), evaluated_links.join(', ')])
        end
        
        csv << csv_row
      end
    end
  end

  def self.generate_csv_header_row
    ['User Name', 'User ID', 'User Email', 'Team Name', 'Project Level',
     'Adviser Name', 'Has Dropped', 'Team ID', 'Evaluated Teams IDs', 'Evaluated Proposal links']
  end

  def get_teammates
    return [] if team_id.blank?
    team.students.select { |student| student.id != id }
  end

  def adviser
    return nil if team_id.blank?
    team.adviser unless team.adviser_id.blank?
  end

  def team_adviser_info
    row = []
    if !team_id.blank?
      row.concat([team.team_name, team.get_project_level])
      if !team.adviser_id.blank?
        row.append(team.adviser.user.user_name)
      else
        row.append(nil)
      end
      row.append(team.has_dropped)
    else
      row.concat(%w(nil nil nil nil))
    end
    row
  end
end

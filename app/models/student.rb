class Student < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {message: 'can have only one student role'}

  belongs_to :user
  belongs_to :team

  def self.student?(user_id)
    Student.find_by(user_id: user_id)
  end

  def self.to_csv(**options)
    require 'csv'
    CSV.generate(options) do |csv|
      csv << ['User Name', 'User Email', 'Team Name', 'Project Level', 'Adviser Name', 'Has Dropped']
      all.each do |student|
        csv_row = [student.user.user_name, student.user.email]
        if student.team
          csv_row.concat([student.team.team_name, student.team.get_project_level])
          if student.team.adviser
            csv_row.append(student.team.adviser.user.user_name)
          else
            csv_row.append(nil)
          end
          csv_row.append(student.team.has_dropped)
        else
          csv_row.concat(%w(nil nil nil nil))
        end
        csv << csv_row
      end
    end
  end

  def get_teammates
    if self.team_id.blank?
      return []
    end
    teammates = []
    self.team.students.each do |student|
      if student.id != self.id
        teammates.push(student)
      end
    end
    teammates
  end

  def adviser
    if self.team_id.blank?
      return nil
    end
    if self.team.adviser_id.blank?
      nil
    else
      self.team.adviser
    end
  end
end

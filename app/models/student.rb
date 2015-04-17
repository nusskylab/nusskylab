class Student < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  belongs_to :team

  def self.create_or_update_by_user_id(info_hash)
    student = Student.find_by(user_id: info_hash[:user_id]) || Student.new
    info_hash.each_pair do |key, value|
      if student.has_attribute?(key) and (not value.blank?)
        student[key] = value
      end
    end
    if student.team_id and student.team.team_name.to_s == info_hash[:team_name].to_s
      student.team.update_attributes(team_name: info_hash[:team_name],
                                     project_title: info_hash[:project_title],
                                     project_level: info_hash[:project_level])
    else
      t = Team.create_or_update_by_team_name(team_name: info_hash[:team_name],
                                             project_title: info_hash[:project_title],
                                             project_level: info_hash[:project_level])
      student.team_id = t.id
      student.save
    end
    return student
  end

  def self.is_a_student(user_id)
    Student.find_by(user_id: user_id)
  end
end

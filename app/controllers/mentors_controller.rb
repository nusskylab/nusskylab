class MentorsController < ApplicationController
  layout 'advisers_mentors'

  def index
    @mentors = Mentor.all
  end

  def new
    @mentor = Mentor.new
    render locals: {
             user: nil,
             users: User.all
           }
  end

  def create
    user = User.new(get_user_params)
    flash = {}
    if not user.save
      render 'new', locals: {
               user: user,
               users: User.all
                  } and return
    end
    @mentor = Mentor.new(user_id: user.id)
    if @mentor.save
      flash[:success] = 'The mentor is successfully created'
      redirect_to mentors_path, flash: flash
    else
      render 'new', locals: {
                    user: user,
                    users: User.all
                  }
    end
  end

  def use_existing
    user = User.find(params[:mentor][:user_id])
    if not user
      render 'new', locals: {
                    users: User.all,
                    user: user
                  } and return
    end
    @mentor = Mentor.new(user_id: user.id)
    if @mentor.save
      flash = {}
      flash[:success] = 'The mentor is successfully created'
      redirect_to mentors_path, flash: flash
    else
      render 'new', locals: {
                    user: user,
                    users: User.all
                  }
    end
  end

  def show
    @mentor = Mentor.find(params[:id])
    milestones, teams_submissions, own_evaluations = get_data_for_adviser
    render locals: {
             milestones: milestones,
             teams_submissions: teams_submissions,
             own_evaluations: own_evaluations
           }
  end

  def edit
    @mentor = Mentor.find(params[:id])
  end

  def update
    @mentor = Mentor.find(params[:id])
    user = @mentor.user
    if user.update(get_user_params)
      redirect_to @mentor
    else
      render 'edit'
    end
  end

  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy
    redirect_to mentors_path
  end

  private
    def get_user_params
      user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
    end

    def get_data_for_adviser
      milestones = Milestone.all
      teams_submissions = {}
      own_evaluations = {}
      milestones.each do |milestone|
        teams_submissions[milestone.id] = {}
        @mentor.teams.each do |team|
          teams_submissions[milestone.id][team.id] = Submission.find_by(milestone_id: milestone.id,
                                                                        team_id: team.id)
        end
      end
      return milestones, teams_submissions, own_evaluations
    end
end

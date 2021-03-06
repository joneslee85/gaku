module Gaku
  class Students::SimpleGradesController < GakuController

    #skip_load_and_authorize_resource only: :index
    skip_authorization_check

    #load_and_authorize_resource :student, class: Gaku::Student
    #load_and_authorize_resource :simple_grade, through: :student, class: Gaku::SimpleGrade

    inherit_resources
    belongs_to :student
    respond_to :js, :html, :json

    before_filter :load_data
    before_filter :student
    before_filter :count, only: [:index, :create, :destroy, :update]
    before_filter :simple_grades, only: :update


    protected

    def collection
      @simple_grades ||= end_of_association_chain.accessible_by(current_ability)
    end

    def begin_of_association_chain
      @student
    end

    def resource_params
      return [] if request.get?
      [params.require(:simple_grade).permit(simple_grade_attr)]
    end

    private

    def simple_grade_attr
      %i(name grade school_id)
    end

    def load_data
      @schools = Gaku::School.all.map { |s| [s.name, s.id] }
    end

    def student
      @student = Student.find(params[:student_id])
    end

    def count
      @count = SimpleGrade.count
    end

    def simple_grades
      @simple_grades = @student.simple_grades
    end


  end
end

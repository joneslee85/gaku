module Gaku
  class CourseGroups::CourseGroupEnrollmentsController < GakuController

    load_and_authorize_resource :course_group_enrollment,
                                class: 'Gaku::CourseGroupEnrollment'

    inherit_resources
    respond_to :js, only: %i( new create destroy )

    before_filter :course_group, only: %i( new create destroy )
    before_filter :count,        only: %i( create destroy )

    def create
      @course_group_enrollment = CourseGroupEnrollment.new(course_group_enrollment_params)
      if @course_group_enrollment.save
        flash.now[:notice] = t(:'notice.added', resource: t(:'course.singular'))
        respond_with @course_group_enrollment
      else
        render :error
      end
    end

    protected

    def resource_params
      return [] if request.get?
      [params.require(:course_group_enrollment).permit(course_group_enrollment_attr)]
    end

    private

    def course_group_enrollment_attr
      %i(course_id course_group_id)
    end

    def course_group_enrollment_params
      params.require(:course_group_enrollment).permit(course_group_enrollment_attr)
    end

    def course_group
      @course_group = CourseGroup.find(params[:course_group_id])
    end

    def count
      course_group
      @count = @course_group.courses.count
    end

  end
end

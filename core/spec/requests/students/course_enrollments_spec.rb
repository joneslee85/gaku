require 'spec_helper'
require 'support/requests/course_enrollable_spec'

describe 'Student Course Enrollments' do

  before { as :admin }

  let(:student) { create(:student) }
  let(:course) { create(:course, code: 'fall2050') }

  before(:all) { set_resource 'student-course-enrollment' }

  context 'new' do
    before do
      @course = course
      visit gaku.edit_student_path(student)
      @data = student
      @select = 'course_enrollment_course_id'
      click tab_link
    end

    it_behaves_like 'enroll to course'

  end

  context 'remove' do

    before do
      student.courses << course
      visit gaku.edit_student_path(student)
      @data = student

      click tab_link
    end

    it_behaves_like 'remove enrollment'
  end

end

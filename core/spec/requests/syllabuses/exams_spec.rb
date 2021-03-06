require 'spec_helper'

describe 'Syllabus Exams' do

  before { as :admin }

  let(:exam) { create(:exam) }
  let(:syllabus) { create(:syllabus, name: 'Biology', code: 'bio') }
  let(:exam) { create(:exam, name: 'Astronomy Exam') }
  let!(:count_div) { '.exams-count' }

  existing_exam_form           = '#new-existing-exam'
  new_existing_exam_link       = '#new-existing-exam-link'
  submit_existing_exam_button  = '#submit-existing-exam-button'
  cancel_existing_exam_link    = '#cancel-existing-exam-link'

  before :all do
    set_resource 'syllabus-exam'
  end

  context 'existing exam' do
    before do
      exam
      syllabus
      visit gaku.syllabuses_path

      within('#syllabuses-index tbody tr:nth-child(1)') { click edit_link }
      page.should have_content 'No Exams'
    end

    it 'adds existing exam', js: true do
      within(count_div) { page.should have_content 'Exams list' }
      click new_existing_exam_link
      wait_until_visible submit_existing_exam_button

      select exam.name, from: 'exam_syllabus_exam_id'
      click submit_existing_exam_button

      wait_until_invisible existing_exam_form
      page.should have_content exam.name
      flash? 'successfully added'
      within(count_div) { page.should have_content 'Exams list(1)' }
    end

    xit 'cancels adding existing exam', cancel: true, js: true do
      click new_existing_exam_link
      wait_until_visible submit_existing_exam_button
      invisible? new_existing_exam_link

      click cancel_existing_exam_link
      wait_until_invisible existing_exam_form
      visible? new_existing_exam_link
    end
  end

  context 'new exam' do
    context 'new' do
      before do
        syllabus
        visit gaku.syllabuses_path
        within('#syllabuses-index tbody tr:nth-child(1)') { click edit_link }
        page.should have_content 'No Exams'
        click new_link
        wait_until_visible submit
      end

      it 'creates and shows', js: true  do
        within(count_div) { page.should have_content 'Exams list' }
        expect do
          #required
          fill_in 'exam_name', with: 'Biology Exam'
          fill_in 'exam_exam_portions_attributes_0_name' , with: 'Biology Exam Portion'
          click submit
          wait_until_invisible submit
        end.to change(syllabus.exams, :count).by 1

        page.should have_content 'Biology Exam'
        page.should_not have_content 'No Exams'
        within(count_div) { page.should have_content 'Exams list(1)' }
        flash_created?
      end

      it 'errors without the required fields', js: true do
        fill_in 'exam_exam_portions_attributes_0_name', with: ''
        has_validations?

        syllabus.exams.count.should eq 0
      end

      it 'cancels creating', cancel: true, js: true do
        ensure_cancel_creating_is_working
      end
    end

    context 'created exam' do
      before do
        syllabus.exams << exam
        visit gaku.edit_syllabus_path(syllabus)
      end

      it 'edits', js: true do
        click js_edit_link
        wait_until_visible modal

        fill_in 'exam_name', with: 'Ruby Exam'
        click submit

        page.should have_content 'Ruby Exam'

        flash_updated?
      end

      it 'shows'  do
        click show_link
        page.should have_content 'Show Exam'
        page.should have_content 'Exam portions list'
        page.should have_content 'Astronomy Exam'
        current_path.should == gaku.exam_path(id: exam.id)
      end

      it 'deletes', js: true do
        page.should have_content exam.name
        within(count_div) { page.should have_content 'Exams list(1)' }

        expect do
          ensure_delete_is_working
        end.to change(syllabus.exams, :count).by -1

        within(table){ page.should_not have_content exam.name }
        within(count_div) { page.should_not have_content 'Exams list(1)' }
        flash_destroyed?
      end
    end
  end

  context 'links hiding' do
    before do
      syllabus
      visit gaku.syllabuses_path
      within('#syllabuses-index tbody tr:nth-child(1)') { click edit_link }
    end

    it 'clicking on new-existing-exam-link hides new-exam form', js: true do
      click new_link
      wait_until_visible form

      click new_existing_exam_link
      wait_until_visible existing_exam_form
      invisible? new_existing_exam_link

      wait_until_invisible form
      visible? new_link
    end

    it 'clicking on new-syllabus-exam-link hides add-existing-exam form', js: true do
      click new_existing_exam_link
      wait_until_visible existing_exam_form

      click new_link
      wait_until_visible form
      invisible? new_link

      wait_until_invisible existing_exam_form
      visible? new_existing_exam_link
    end
  end

end

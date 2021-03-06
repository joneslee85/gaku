module Gaku
  module PersonHelper

    def gender(student)
      if student.gender.nil?
        ''
      else
        if student.gender?
          t(:"gender.male")
        else
          t(:"gender.female")
        end
      end
    end


    def big_person_caption_for(person)
      content_tag :caption do
        content_tag :h2 do
          person_caption_for(person)
        end
      end
    end

    def person_caption_for(person)
      content_tag :ruby do
        concat student_names(person)
        concat content_tag(:rt) { student_names person, reading: true }
      end
    end

    def student_names(student, options = {})
      @names_preset ||= Gaku::Preset.get(:names)
      reading = options[:reading]
      if @names_preset.blank?
        return reading ? student.surname : student.name
      end
      result = @names_preset.gsub(/%(\w+)/) do |name|
        case name
        when '%first' then proper_name(student, :name, reading)
        when '%middle' then proper_name(student, :middle_name, reading)
        when '%last' then proper_name(student, :surname, reading)
        end
      end
      result.gsub(/\s+/, ' ').strip
    end

    private

    def proper_name(student, attribute, reading)
      reading ? student.send(attribute.to_s + '_reading') : student.send(attribute)
    end

  end
end

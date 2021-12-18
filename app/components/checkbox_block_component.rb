# frozen_string_literal: true

# custom checkbox
class CheckboxBlockComponent < ViewComponent::Base

  def initialize(**options)
    super

    @id = options[:id].blank? ? SecureRandom.alphanumeric(5) : options[:id]
    @name = options[:name]
    @title = options[:title]
    @checked = options[:checked]
    @required = options[:required].nil? ? true : options[:required]
    @div_classes = options[:div_classes].nil? ? 'form-check form-check-inline mb-1' : options[:div_classes]
    @input_classes = options[:input_classes].nil? ? 'form-check-input' : options[:input_classes]
    @read_only = options[:read_only].nil? ? false : options[:read_only]
    @disabled = options[:disabled].nil? ? false : options[:disabled]
  end

end

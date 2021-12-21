# frozen_string_literal: true

# custom switch
class SwitchBlockComponent < ViewComponent::Base

  DEFAULT_DIV_CLASSES = 'form-check form-switch mb-1'

  def initialize(**options)
    super

    @id = options[:id].blank? ? SecureRandom.alphanumeric(5) : options[:id]
    @name = options[:name]
    @title = options[:title]
    @checked = options[:checked]
    @required = options[:required].nil? ? false : options[:required]
    @div_classes = options[:div_classes].nil? ? DEFAULT_DIV_CLASSES : options[:div_classes]
    @input_classes = options[:input_classes].nil? ? 'form-check-input' : options[:input_classes]
    @label_classes = options[:label_classes].nil? ? 'form-check-label' : options[:label_classes]
    @read_only = options[:read_only].nil? ? false : options[:read_only]
    @disabled = options[:disabled].nil? ? false : options[:disabled]
  end

end

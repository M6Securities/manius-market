# frozen_string_literal: true

# standard input block
class InputBlockComponent < ViewComponent::Base

  # options
  # {
  #   value: input value,
  #   placeholder: placeholder
  #   type: default text
  #   required: default true
  #   helper_text: helper text under the input
  #   div_classes: replaces default div classes
  #   input_classes: replaces default input classes
  #   read_only: default false
  #   disabled: default false
  # }
  DEFAULT_DIV_CLASSES = 'form-floating mt-2 mb-3'

  def initialize(**options)
    super

    @id = options[:id].blank? ? SecureRandom.alphanumeric(5) : options[:id]
    @name = options[:name]
    @title = options[:title]
    @value = options[:value]
    @placeholder = options[:placeholder]
    @type = options[:type].blank? ? 'text' : options[:type]
    @required = options[:required].nil? ? true : options[:required]
    @helper_text = options[:helper_text]
    @div_classes = options[:div_classes].nil? ? DEFAULT_DIV_CLASSES : options[:div_classes]
    @input_classes = options[:input_classes].nil? ? 'form-control' : options[:input_classes]
    @read_only = options[:read_only].nil? ? false : options[:read_only]
    @disabled = options[:disabled].nil? ? false : options[:disabled]
    @autofocus = options[:autofocus].nil? ? false : options[:autofocus].nil?
    @autocomplete = options[:autocomplete].blank? ? '' : options[:autocomplete]

  end

end

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
  DEFAULT_DIV_CLASSES = 'mb-1'
  DEFAULT_FLOATING_DIV_CLASSES = 'form-floating mt-2 mb-1'

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
    @input_classes = options[:input_classes].nil? ? 'form-control' : options[:input_classes]
    @read_only = options[:read_only].nil? ? false : options[:read_only]
    @disabled = options[:disabled].nil? ? false : options[:disabled]
    @autofocus = options[:autofocus].nil? ? false : options[:autofocus].nil?
    @autocomplete = options[:autocomplete].blank? ? '' : options[:autocomplete]
    @floating = options[:floating].nil? ? false : options[:floating]
    @div_classes = if options[:div_classes].nil?
                     if @floating
                       DEFAULT_FLOATING_DIV_CLASSES
                     else
                       DEFAULT_DIV_CLASSES
                     end
                   else
                     options[:div_classes]
                   end
  end
end

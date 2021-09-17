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
  # }


  def initialize(
    id,
    name,
    title,
    **options
  )

    @id = id
    @name = name
    @title = title

    @value = options[:value]
    @placeholder = options[:placeholder]
    @type = options[:type].blank? ? 'text' : options[:type]
    @required = options[:required].nil? ? true : options[:required]
    @helper_text = options[:helper_text]
    @div_classes = options[:div_classes].blank? ? 'mb-1' : options[:div_classes]
    @input_classes = options[:input_classes].blank? ? 'form-control' : options[:input_classes]

  end

  def render?
    @id.present?
    @name.present?
    @title.present?
  end


end

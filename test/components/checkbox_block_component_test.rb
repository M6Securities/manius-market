# frozen_string_literal: true

require 'test_helper'

class CheckboxBlockComponentTest < ViewComponent::TestCase
  def test_basic_render
    assert_equal(
      %(<div class="form-check form-check-inline mb-1">
  <input class="form-check-input" type="checkbox" id="checkbox_id" name="test" checked required>
  <label class="form-check-label" for="checkbox_id">Test</label>
</div>),
      render_inline(CheckboxBlockComponent.new(name: 'test', title: 'Test', checked: true, id: 'checkbox_id')).to_html
    )
  end

  def test_basic_render_unchecked
    assert_equal(
      %(<div class="form-check form-check-inline mb-1">
  <input class="form-check-input" type="checkbox" id="checkbox_id" name="test" required>
  <label class="form-check-label" for="checkbox_id">Test</label>
</div>),
      render_inline(CheckboxBlockComponent.new(name: 'test', title: 'Test', id: 'checkbox_id')).to_html
    )
  end

  def test_read_only_and_disabled
    assert_equal(
      %(<div class="form-check form-check-inline mb-1">
  <input class="form-check-input" type="checkbox" id="checkbox_id" name="test" required read_only disabled>
  <label class="form-check-label" for="checkbox_id">Test</label>
</div>),
      render_inline(CheckboxBlockComponent.new(name: 'test', title: 'Test', id: 'checkbox_id', read_only: true, disabled: true)).to_html
    )
  end
end

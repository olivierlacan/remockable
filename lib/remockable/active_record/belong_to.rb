RSpec::Matchers.define(:belong_to) do |*association|
  extend Remockable::ActiveRecord::Helpers

  @expected = association.extract_options!
  @association = association.shift

  valid_options %w(class_name foreign_key foreign_type primary_key dependent
    counter_cache polymorphic validate autosave touch inverse_of)

  match do |actual|
    if association = subject.class.reflect_on_association(@association)
      macro_matches = association.macro == :belongs_to
      options_match = association.options.slice(*expected.keys) == expected
      macro_matches && options_match
    end
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{expected.inspect}" if expected.any?
    "belong to #{@association}#{with}"
  end
end

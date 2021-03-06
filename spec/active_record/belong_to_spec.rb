require 'spec_helper'

describe :belong_to do
  let(:macro) { :belongs_to }
  let(:options) { [:company, { :dependent => :destroy }] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before do
      create_table(:users) { |table| table.integer(:company_id) }
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected.inspect}" if matcher.expected.any?
        matcher.description.should == "#{name} #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :company }

      it 'matches if the association exists' do
        model.belongs_to(*options)
        model.should belong_to(*options)
      end

      it 'does not match if the association does not exist' do
        model.should_not belong_to(*options)
      end

      it 'does not match if the association is of the wrong type' do
        model.has_many(*options)
        model.should_not belong_to(*options)
      end
    end

    with_option(:class_name, 'Company', 'Organization')
    with_option(:foreign_key, :company_id, :organization_id)
    with_option(:foreign_type, :company_type, :organization_type)
    with_option(:primary_key, :id, :company_id)
    with_option(:dependent, :destroy, :nullify)
    with_option(:counter_cache, true, false)
    with_option(:polymorphic, true, false)
    with_option(:validate, true, false)
    with_option(:autosave, true, false)
    with_option(:touch, true, false)
    with_option(:inverse_of, :users, :employees)
  end
end

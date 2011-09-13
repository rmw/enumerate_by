#require File.dirname(__FILE__) + '/../test_helper'
require 'test_helper'

class EnumerateByTest < ActiveRecord::TestCase
  def test_should_raise_exception_if_invalid_option_specified
    assert_raise(ArgumentError) { Color.enumerate_by(:id, :invalid => true) }
  end
end

class ModelWithoutEnumerationTest < ActiveRecord::TestCase
  def test_should_not_be_an_enumeration
    assert !Car.enumeration?
  end
  
  def test_should_be_able_to_bootstrap
    Car.class_eval do
      extend EnumerateBy::Bootstrapped
    end
    
    Car.bootstrap(
      {:id => 1, :name => 'Ford Mustang'},
      {:id => 2, :name => 'Ford Explorer'}
    )
    
    assert_equal 2, Car.count
  end
end

#class EnumerationByDefaultTest < ActiveRecord::TestCase
#  def setup
#    @color = Color.new
#  end
#  
#  def test_should_not_have_an_id
#    assert @color.id.blank?
#  end
#  
#  def test_should_not_have_a_name
#    assert @color.name.blank?
#  end
#  
#  def test_should_not_have_an_enumerator
#    assert @color.enumerator.blank?
#  end
#  
#  def test_should_have_empty_stringify
#    assert_equal '', @color.to_s
#  end
#end
#
#class EnumerationTest < ActiveRecord::TestCase
#  def test_should_be_an_enumeration
#    assert Color.enumeration?
#  end
#  
#  def test_should_have_an_enumerator_attribute
#    assert_equal :name, Color.enumerator_attribute
#  end
#  
#  def test_should_perform_caching
#    assert Color.perform_enumerator_caching
#  end
#  
#  def test_should_have_a_cache_store
#    assert_instance_of ActiveSupport::Cache::MemoryStore, Color.enumerator_cache_store
#  end
#  
#  def test_should_require_a_name
#    color = new_color(:name => nil)
#    assert !color.valid?
#    assert color.errors.any?(:name)
#  end
#  
#  def test_should_require_a_unique_name
#    color = create_color(:name => 'red')
#    
#    second_color = new_color(:name => 'red')
#    assert !second_color.valid?
#    assert second_color.errors.any?(:name)
#  end
#end
#
#class EnumerationWithRecordsTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'red')
#    @green = create_color(:name => 'green')
#  end
#  
#  def test_should_index_by_enumerator
#    assert_equal @red, Color['red']
#  end
#  
#  def test_should_allow_finding_by_enumerator
#    assert_equal @red, Color.find_by_enumerator('red')
#  end
#  
#  def test_should_allow_finding_by_enumerator_with_nil
#    assert_nil Color.find_by_enumerator(nil)
#  end
#  
#  def test_should_find_nothing_if_finding_by_unknown_enumerator
#    assert_nil Color.find_by_enumerator('invalid')
#  end
#  
#  def test_should_raise_exception_for_invalid_index
#    exception = assert_raise(ActiveRecord::RecordNotFound) {Color['white']}
#    assert_equal "Couldn't find Color with name \"white\"", exception.message
#  end
#  
#  def test_should_allow_finding_all_by_enumerator
#    assert_equal [@red, @green], Color.find_all_by_enumerator(['red', 'green'])
#  end
#  
#  def test_should_allow_finding_all_by_enumerator_with_nil
#    assert_equal [], Color.find_all_by_enumerator(nil)
#  end
#  
#  def test_should_find_nothing_if_finding_all_by_unknown_enumerator
#    assert_equal [], Color.find_all_by_enumerator('invalid')
#  end
#  
#  def test_should_raise_exception_find_finding_all_by_unknown_enumerator!
#    exception = assert_raise(ActiveRecord::RecordNotFound) { Color.find_all_by_enumerator!('invalid') }
#    assert_equal "Couldn't find Color with name(s) \"invalid\"", exception.message
#  end
#  
#  def test_should_raise_exception_if_only_some_found_when_finding_all_by_enumerator!
#    exception = assert_raise(ActiveRecord::RecordNotFound) { Color.find_all_by_enumerator!(['red', 'invalid']) }
#    assert_equal "Couldn't find Color with name(s) \"invalid\"", exception.message
#  end
#end
#
#class EnumerationWithSymbolReferencesTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'red')
#    @green = create_color(:name => 'green')
#  end
#  
#  def test_should_index_by_enumerator
#    assert_equal @red, Color[:red]
#  end
#  
#  def test_should_allow_finding_by_enumerator
#    assert_equal @red, Color.find_by_enumerator(:red)
#  end
#  
#  def test_should_allow_finding_by_enumerator_with_nil
#    assert_nil Color.find_by_enumerator(nil)
#  end
#  
#  def test_should_find_nothing_if_finding_by_unknown_enumerator
#    assert_nil Color.find_by_enumerator(:invalid)
#  end
#  
#  def test_should_raise_exception_for_invalid_index
#    exception = assert_raise(ActiveRecord::RecordNotFound) {Color[:white]}
#    assert_equal "Couldn't find Color with name \"white\"", exception.message
#  end
#  
#  def test_should_allow_finding_all_by_enumerator
#    assert_equal [@red, @green], Color.find_all_by_enumerator([:red, :green])
#  end
#  
#  def test_should_allow_finding_all_by_enumerator_with_nil
#    assert_equal [], Color.find_all_by_enumerator(nil)
#  end
#  
#  def test_should_find_nothing_if_finding_all_by_unknown_enumerator
#    assert_equal [], Color.find_all_by_enumerator(:invalid)
#  end
#  
#  def test_should_raise_exception_find_finding_all_by_unknown_enumerator!
#    exception = assert_raise(ActiveRecord::RecordNotFound) { Color.find_all_by_enumerator!(:invalid) }
#    assert_equal "Couldn't find Color with name(s) \"invalid\"", exception.message
#  end
#  
#  def test_should_raise_exception_if_only_some_found_when_finding_all_by_enumerator!
#    exception = assert_raise(ActiveRecord::RecordNotFound) { Color.find_all_by_enumerator!([:red, :invalid]) }
#    assert_equal "Couldn't find Color with name(s) \"invalid\"", exception.message
#  end
#end
#
#class EnumerationAfterBeingCreatedTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'red')
#    @green = create_color(:name => 'green')
#    @blue = create_color(:name => 'blue')
#  end
#  
#  def test_should_have_an_enumerator
#    assert_equal 'red', @red.enumerator
#  end
#  
#  def test_should_allow_equality_with_enumerator
#    assert @red == 'red'
#  end
#  
#  def test_should_allow_equality_with_symbol_enumerator
#    assert @red == :red
#  end
#  
#  def test_should_allow_equality_with_record
#    assert @red == @red
#  end
#  
#  def test_should_allow_equality_with_strings
#    assert 'red' == @red
#  end
#  
#  def test_should_allow_equality_with_nil
#    assert @red != nil
#  end
#  
#  def test_should_raise_exception_on_quality_with_invalid_enumerator
#    assert_raise(ActiveRecord::RecordNotFound) {@red == 'invalid'}
#  end
#  
#  def test_should_be_found_in_a_list_of_valid_names
#    assert @red.in?('red')
#  end
#  
#  def test_should_be_found_in_a_list_of_valid_symbol_names
#    assert @red.in?(:red)
#  end
#  
#  def test_should_not_be_found_in_a_list_of_invalid_names
#    assert !@red.in?('blue', 'green')
#  end
#  
#  def test_should_stringify_enumerator
#    assert_equal 'red', @red.to_s
#    assert_equal 'red', @red.to_str
#  end
#end
#
#class EnumerationWithNumericEnumeratorAttributeTest < ActiveRecord::TestCase
#  def setup
#    @engine = create_car_part(:name => 'engine', :number => 111)
#    @radiator = create_car_part(:name => 'radiator', :number => 222)
#    @transmission = create_car_part(:name => 'transmission', :number => 333)
#  end
#  
#  def test_should_have_an_enumerator
#    assert_equal 111, @engine.enumerator
#  end
#  
#  def test_should_allow_equality_with_enumerator
#    assert @engine == 111
#  end
#  
#  def test_should_allow_equality_with_record
#    assert @engine == @engine
#  end
#  
#  def test_should_allow_equality_with_strings
#    assert '111' == @engine
#  end
#  
#  def test_should_raise_exception_on_quality_with_invalid_enumerator
#    assert_raise(ActiveRecord::RecordNotFound) {@engine == 123}
#  end
#  
#  def test_should_be_found_in_a_list_of_valid_names
#    assert @engine.in?(111)
#  end
#  
#  def test_should_not_be_found_in_a_list_of_invalid_names
#    assert !@engine.in?(222, 333)
#  end
#  
#  def test_should_stringify_enumerator
#    assert_equal '111', @engine.to_s
#    assert_equal '111', @engine.to_str
#  end
#end
#
#class EnumerationWithCachingTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'red')
#    
#    EnumerateBy.perform_caching = true
#  end
#  
#  def test_should_perform_enumerator_caching
#    assert Color.perform_enumerator_caching
#  end
#  
#  def test_should_not_return_same_objects
#    assert_not_same Color.find(@red.id), Color.find(@red.id)
#  end
#  
#  def test_should_not_return_same_collections
#    assert_not_same Color.find_all_by_id(@red.id), Color.find_all_by_id(@red.id)
#  end
#  
#  def test_should_cache_all_finder_queries
#   assert_queries(1) { Color.find(@red.id) }
#   assert_queries(0) { Color.find(@red.id) }
#   
#   assert_queries(1) { Color.all }
#   assert_queries(0) { Color.all }
#  end
#  
#  def test_should_cache_exist_queries
#    assert_queries(1) { Color.exists?(:name => 'red') }
#    assert_queries(0) { Color.exists?(:name => 'red') }
#  end
#  
#  def test_should_cache_calculate_queries
#    assert_queries(1) { Color.minimum('id') }
#    assert_queries(0) { Color.minimum('id') }
#  end
#  
#  def test_should_skip_cache_when_in_uncached_block
#    Color.uncached do
#     assert_queries(1) { Color.find(@red.id) }
#     assert_queries(1) { Color.find(@red.id) }
#    end
#  end
#  
#  def teardown
#    Color.enumerator_cache_store.clear
#    EnumerateBy.perform_caching = false
#  end
#end
#
#class EnumerationWithoutCachingTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'red')
#    
#    EnumerateBy.perform_caching = true
#    @original_perform_caching = Color.perform_enumerator_caching
#    Color.perform_enumerator_caching = false
#  end
#  
#  def test_should_not_cache_finder_queries
#   assert_queries(1) { Color.find(@red.id) }
#   assert_queries(1) { Color.find(@red.id) }
#   
#   assert_queries(1) { Color.all }
#   assert_queries(1) { Color.all }
#  end
#  
#  def test_should_not_cache_exist_queries
#    assert_queries(1) { Color.exists?(:name => 'red') }
#    assert_queries(1) { Color.exists?(:name => 'red') }
#  end
#  
#  def test_should_not_cache_calculate_queries
#    assert_queries(1) { Color.minimum('id') }
#    assert_queries(1) { Color.minimum('id') }
#  end
#  
#  def teardown
#    EnumerateBy.perform_caching = false
#    Color.perform_enumerator_caching = @original_perform_caching
#  end
#end
#
#class EnumerationWithAssociationsTest < ActiveRecord::TestCase
#  def setup
#    EnumerateBy.perform_caching = true
#    
#    @red = create_color(:name => 'red')
#    @blue = create_color(:name => 'blue')
#    @red_car = create_car(:name => 'Ford Mustang', :color => @red)
#    @blue_car = create_car(:name => 'Ford Mustang', :color => @blue)
#  end
#  
#  def test_should_find_associated_records
#    assert_equal [@red_car], Color['red'].cars
#  end
#  
#  def test_should_not_cache_association_on_subsequent_usage
#    assert_equal [@red_car], Color['red'].cars
#    
#    @second_red_car = create_car(:name => 'Ford Mustang', :color => @red)
#    assert_equal [@red_car, @second_red_car], Color['red'].cars
#  end
#  
#  def teardown
#    Color.enumerator_cache_store.clear
#    EnumerateBy.perform_caching = false
#  end
#end
#
#class EnumerationBootstrappedTest < ActiveRecord::TestCase
#  def setup
#    @red, @green = Color.bootstrap(
#      {:id => 1, :name => 'red'},
#      {:id => 2, :name => 'green'}
#    )
#  end
#  
#  def test_should_not_raise_exception_if_id_not_specified
#    assert_nothing_raised { Color.bootstrap({:name => 'red'}, {:name => 'green'}) }
#    assert_equal 2, Color.count
#  end
#  
#  def test_should_raise_exception_if_validation_fails
#    assert_raise(ActiveRecord::RecordInvalid) { Color.bootstrap({:id => 1, :name => nil}, {:id => 2, :name => 'green'}) }
#  end
#  
#  def test_should_flatten_bootstrap_records
#    Color.bootstrap(
#      [{:id => 1, :name => 'red'}],
#      [{:id => 2, :name => 'green'}]
#    )
#    assert_equal 2, Color.count
#  end
#  
#  def test_should_create_records
#    assert_equal @red, Color.find(1)
#    assert_equal 'red', @red.name
#    
#    assert_equal @green, Color.find(2)
#    assert_equal 'green', @green.name
#  end
#end
#
#class EnumerationBootstrappedWithExistingRecordsTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'RED')
#    @green = create_color(:name => 'GREEN')
#  
#    Color.bootstrap(
#      {:id => @red.id, :name => 'red'},
#      {:id => @green.id, :name => 'green'}
#    )
#    
#    @red.reload
#    @green.reload
#  end
#  
#  def test_should_synchronize_all_attributes
#    assert_equal 'red', @red.name
#    assert_equal 'green', @green.name
#  end
#end
#
#class EnumerationBootstrappedWithExistingDynamicRecordsTest < ActiveRecord::TestCase
#  def setup
#    create_color(:name => 'RED')
#    create_color(:name => 'GREEN')
#  
#    @red, @green = Color.bootstrap(
#      {:name => 'red'},
#      {:name => 'green'}
#    )
#  end
#  
#  def test_should_synchronize_all_attributes
#    assert_equal 2, Color.count
#    
#    assert_equal 'red', @red.name
#    assert_equal 'green', @green.name
#  end
#end
#
#class EnumerationBootstrappedWithDefaultsTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'RED', :html => '#f00')
#    @green = create_color(:name => 'GREEN')
#  
#    Color.bootstrap(
#      {:id => @red.id, :name => 'red', :defaults => {:html => '#ff0000'}},
#      {:id => @green.id, :name => 'green', :defaults => {:html => '#00ff00'}}
#    )
#    
#    @red.reload
#    @green.reload
#  end
#  
#  def test_should_update_all_non_default_attributes
#    assert_equal 'red', @red.name
#    assert_equal 'green', @green.name
#  end
#  
#  def test_should_not_update_default_attributes_if_defined
#    assert_equal '#f00', @red.html
#  end
#  
#  def test_should_update_default_attributes_if_not_defined
#    assert_equal '#00ff00', @green.html
#  end
#end
#
#class EnumerationWithCustomPrimaryKeyBootstrappedTest < ActiveRecord::TestCase
#  def setup
#    @red, @green = LegacyColor.bootstrap(
#      {:uid => 1, :name => 'red'},
#      {:uid => 2, :name => 'green'}
#    )
#  end
#  
#  def test_should_not_raise_exception_if_primary_key_not_specified
#    assert_nothing_raised { LegacyColor.bootstrap({:name => 'red'}, {:name => 'green'}) }
#    assert_equal 2, LegacyColor.count
#  end
#  
#  def test_should_create_records
#    assert_equal @red, LegacyColor.find(1)
#    assert_equal 'red', @red.name
#    
#    assert_equal @green, LegacyColor.find(2)
#    assert_equal 'green', @green.name
#  end
#end
#
#class EnumerationFastBootstrappedTest < ActiveRecord::TestCase
#  def setup
#    @result = Color.fast_bootstrap(
#      {:id => 1, :name => 'red'},
#      {:id => 2, :name => 'green'}
#    )
#  end
#  
#  def test_should_not_raise_exception_if_id_not_specified
#    assert_nothing_raised { Color.fast_bootstrap({:name => 'red'}, {:name => 'green'}) }
#    assert_equal 2, Color.count
#  end
#  
#  def test_should_raise_exception_if_query_fails
#    assert_raise(ActiveRecord::StatementInvalid) { Color.fast_bootstrap({:id => 1, :name => nil}, {:id => 2, :name => 'green'}) }
#  end
#  
#  def test_should_flatten_bootstrap_records
#    Color.bootstrap(
#      [{:id => 1, :name => 'red'}],
#      [{:id => 2, :name => 'green'}]
#    )
#    assert_equal 2, Color.count
#  end
#  
#  def test_should_create_records
#    assert @result
#    assert_not_nil Color.find_by_name('red')
#    assert_not_nil Color.find_by_name('green')
#  end
#end
#
#class EnumeratioFastBootstrappedWithExistingRecordsTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'RED')
#    @green = create_color(:name => 'GREEN')
#  
#    Color.fast_bootstrap(
#      {:id => @red.id, :name => 'red'},
#      {:id => @green.id, :name => 'green'}
#    )
#    
#    @red.reload
#    @green.reload
#  end
#  
#  def test_should_synchronize_all_attributes
#    assert_equal 'red', @red.name
#    assert_equal 'green', @green.name
#  end
#end
#
#class EnumerationFastBootstrappedWithExistingDynamicRecordsTest < ActiveRecord::TestCase
#  def setup
#    create_color(:name => 'RED')
#    create_color(:name => 'GREEN')
#  
#    Color.fast_bootstrap(
#      {:name => 'red'},
#      {:name => 'green'}
#    )
#  end
#  
#  def test_should_synchronize_all_attributes
#    assert_equal 2, Color.count
#    
#    assert Color.exists?(:name => 'red')
#    assert Color.exists?(:name => 'green')
#  end
#end
#
#class EnumerationFastBootstrappedWithDefaultsTest < ActiveRecord::TestCase
#  def setup
#    @red = create_color(:name => 'RED', :html => '#f00')
#    @green = create_color(:name => 'GREEN')
#  
#    Color.fast_bootstrap(
#      {:id => @red.id, :name => 'red', :defaults => {:html => '#ff0000'}},
#      {:id => @green.id, :name => 'green', :defaults => {:html => '#00ff00'}}
#    )
#    
#    @red.reload
#    @green.reload
#  end
#  
#  def test_should_update_all_non_default_attributes
#    assert_equal 'red', @red.name
#    assert_equal 'green', @green.name
#  end
#  
#  def test_should_not_update_default_attributes_if_defined
#    assert_equal '#f00', @red.html
#  end
#  
#  def test_should_update_default_attributes_if_not_defined
#    assert_equal '#00ff00', @green.html
#  end
#end
#
#class EnumerationWithCustomPrimaryKeyFastBootstrappedTest < ActiveRecord::TestCase
#  def setup
#    @result = LegacyColor.fast_bootstrap(
#      {:uid => 1, :name => 'red'},
#      {:uid => 2, :name => 'green'}
#    )
#  end
#  
#  def test_should_not_raise_exception_if_primary_key_not_specified
#    assert_nothing_raised { LegacyColor.fast_bootstrap({:name => 'red'}, {:name => 'green'}) }
#    assert_equal 2, LegacyColor.count
#  end
#  
#  def test_should_create_records
#    assert @result
#    assert_not_nil LegacyColor.find_by_name('red')
#    assert_not_nil LegacyColor.find_by_name('green')
#  end
#end

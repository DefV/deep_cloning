require File.dirname(__FILE__) + '/test_helper'

class DeepCloningTest < ActiveSupport::TestCase
  fixtures :pirates, :gold_pieces, :treasures, :mateys, :parrots

  def setup
    @jack = Pirate.find(pirates(:jack).id)
    @polly= Parrot.find(parrots(:polly).id)
  end

  def test_single_clone_exception
    clone = @jack.dup(:except => :name)
    assert clone.save
    assert_equal pirates(:jack).name, @jack.dup.name # Old behavour
    assert_nil clone.name
    assert_equal pirates(:jack).nick_name, clone.nick_name
  end
  
  def test_multiple_clone_exception
    clone = @jack.dup(:except => [:name, :nick_name])
    assert clone.save
    assert_nil clone.name
    assert_equal 'no nickname', clone.nick_name
    assert_equal pirates(:jack).age, clone.age
  end
  
  def test_single_include_association
    clone = @jack.dup(:include => :mateys)
    assert clone.save
    assert_equal 1, clone.mateys.size
  end
  
  def test_multiple_include_association
    clone = @jack.dup(:include => [:mateys, :treasures])
    assert clone.save
    assert_equal 1, clone.mateys.size
    assert_equal 1, clone.treasures.size
  end
  
  def test_deep_include_association
    clone = @jack.dup(:include => {:treasures => :gold_pieces})
    assert clone.save
    assert_equal 1, clone.treasures.size
    assert_equal 1, clone.gold_pieces.size
  end
  
  def test_multiple_and_deep_include_association
    clone = @jack.dup(:include => {:treasures => :gold_pieces, :mateys => {}})
    assert clone.save
    assert_equal 1, clone.treasures.size
    assert_equal 1, clone.gold_pieces.size
    assert_equal 1, clone.mateys.size
  end
  
  def test_multiple_and_deep_include_association_with_array
    clone = @jack.dup(:include => [{:treasures => :gold_pieces}, :mateys])
    assert clone.save
    assert_equal 1, clone.treasures.size
    assert_equal 1, clone.gold_pieces.size
    assert_equal 1, clone.mateys.size
  end
  
  def test_with_belongs_to_relation
    clone = @jack.dup(:include => :parrot)
    assert clone.save
    assert_not_equal clone.parrot, @jack.parrot
  end
end

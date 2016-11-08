require 'active_record'

# DeepCloning

module DeepCloning
  def self.included(base) #:nodoc:
    base.alias_method_chain :dup, :deep_cloning
  end

  # dups an ActiveRecord model. 
  # if passed the :include option, it will deep dup the given associations
  # if passed the :except option, it won't dup the given attributes
  #
  # === Usage:
  # 
  # ==== Cloning a model without an attribute
  #   pirate.dup :except => :name
  # 
  # ==== Cloning a model without multiple attributes
  #   pirate.dup :except => [:name, :nick_name]
  # ==== Cloning one single association
  #   pirate.dup :include => :mateys
  #
  # ==== Cloning multiple associations
  #   pirate.dup :include => [:mateys, :treasures]
  #
  # ==== Cloning really deep
  #   pirate.dup :include => {:treasures => :gold_pieces}
  #
  # ==== Cloning really deep with multiple associations
  #   pirate.dup :include => [:mateys, {:treasures => :gold_pieces}]
  #
  def dup_with_deep_cloning options = {}
    kopy = dup_without_deep_cloning()
    
    if options[:except]
      Array(options[:except]).each do |attribute|
        kopy.send("#{attribute}=", self.class.column_defaults[attribute.to_s])
      end
    end
    
    if options[:include]
      Array(options[:include]).each do |association, deep_associations|
        if (association.kind_of? Hash)
          deep_associations = association[association.keys.first]
          association = association.keys.first
        end
        opts = deep_associations.blank? ? {} : {:include => deep_associations}
        cloned_object = case self.class.reflect_on_association(association).macro
                        when :belongs_to, :has_one
                          self.send(association) && self.send(association).dup(opts)
                        when :has_many, :has_and_belongs_to_many
                          self.send(association).collect { |obj| obj.dup(opts) }
                        end
        kopy.send("#{association}=", cloned_object)
      end
    end

    return kopy
  end
end

ActiveRecord::Base.send :include, DeepCloning


module ::SortedArray::Interface

  include ::HookedArray::Interface
  
  instances_identify_as!( ::SortedArray )

  ################
  #  initialize  #
  ################

  def initialize( configuration_instance = nil, & sort_object_block )
    
    super( configuration_instance )
    
    if block_given?
      @sort_object_block = sort_object_block
    end
    
  end

end

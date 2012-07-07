
module ::Array::Sorted::ArrayInterface
  
  include ::Array::Hooked::ArrayInterface
  
  instances_identify_as!( ::Array::Sorted )
  
  ################
  #  initialize  #
  ################

  ###
  # Adds optional block for object by which sort order is determined.
  #
  # @yield [object] Block to use to determine sort order object.
  # @yieldparam object Array member or insert item.
  # @yieldreturn [Object] Object to be used for sort order
  #
  def initialize( configuration_instance = nil, *args, & sort_object_block )
    
    super( configuration_instance, *args )
    
    if block_given?
      @sort_object_block = sort_object_block
    end
    
  end

  #####################
  #  unsorted_insert  #
  #####################

  alias_method :unsorted_insert, :hooked_insert

  ##################
  #  unsorted_set  #
  ##################

  alias_method :unsorted_set, :hooked_set
  
  ##############
  #  reverse!  #
  ##############

  def reverse!
    
    @sort_order_reversed = ! @sort_order_reversed
    
    super
        
    return self
    
  end
  
  ##############
  #  collect!  #
  #  map!      #
  ##############

  def collect!
    
    return to_enum unless block_given?
    
    replacement_array = [ ]
    self.each_with_index do |this_object, index|
      replacement_object = yield( this_object )
      replacement_array[ index ] = replacement_object
    end
    
    replace( replacement_array )
    
    return self
    
  end
  alias_method :map!, :collect!
  
  ###########
  #  sort!  #
  ###########

  def sort!( & block )

    if block_given?
      self.each_with_index do |this_member, index|
        unless index + 1 == count
          sort_object = @sort_object_block ? @sort_object_block.call( this_member ) : this_member
          yield( sort_object, self[ index + 1 ] )
        end
      end
    end
    
    return self

  end

  ##############
  #  sort_by!  #
  ##############

  def sort_by!( & block )

    return to_enum unless block_given?
  
    self.each do |this_member|
      sort_object = @sort_object_block ? @sort_object_block.call( this_member ) : this_member
      yield( sort_object )
    end
    
    return self
    
  end

  ######################################################################################################################
      private ##########################################################################################################
  ######################################################################################################################

  ###############################
  #  perform_set_between_hooks  #
  ###############################

  def perform_set_between_hooks( index, object )

    unless index >= count
      delete_at( index )
    end
    
    index = perform_single_object_insert_between_hooks( index, object )
    
    return false
    
  end
  
  ##################################
  #  perform_insert_between_hooks  #
  ##################################

  def perform_insert_between_hooks( index, *objects )

    # we ignore the index and insert in sorted order

    # we have to have at least one member for comparison-based insert (to retain sorted order)

    objects.each_with_index do |this_object, this_index|
      perform_single_object_insert_between_hooks( index + this_index, this_object )          
    end
    
    # return index our insert began with
    return index
    
  end

  #############################
  #  perform_unsorted_insert  #
  #############################
  
  def perform_unsorted_insert( index, object )
    
    return undecorated_insert( index, object )
    
  end

  #################################
  #  get_index_for_sorted_insert  #
  #################################
  
  def get_index_for_sorted_insert( object )
    
    index = nil
    
    if object.nil?

      index = @sort_order_reversed ? count : 0
    
    else

      self.each_with_index do |this_member, this_index|

        insert_sort_object = object
        existing_sort_object = this_member

        if @sort_object_block
          insert_sort_object = @sort_object_block.call( object )
          existing_sort_object = @sort_object_block.call( object )
        end

        if @sort_order_reversed

          case insert_sort_object <=> existing_sort_object
            when 0, 1
              index = this_index
              break
          end

        else

          case insert_sort_object <=> existing_sort_object
            when 0, -1
              index = this_index
              break
          end

        end

      end

      unless index
        index = count
      end

    end
        
    return index
    
  end

  ################################################
  #  perform_single_object_insert_between_hooks  #
  ################################################
  
  def perform_single_object_insert_between_hooks( index, object )

    insert_index = get_index_for_sorted_insert( object )
    
    perform_unsorted_insert( insert_index, object )
    
    return insert_index
    
  end
  
end

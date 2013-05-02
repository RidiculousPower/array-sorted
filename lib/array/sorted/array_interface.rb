# -*- encoding : utf-8 -*-

module ::Array::Sorted::ArrayInterface
  
  include ::Array::Hooked::ArrayInterface
  
  instances_identify_as!( ::Array::Sorted )
  
  ################
  #  initialize  #
  ################

  ###
  # Adds optional block for object by which sort order is determined.
  #
  # @yield [object] 
  #
  #        Block to use to determine sort order object.
  #
  # @yieldparam object 
  #
  #             Array member or insert item.
  #
  # @yieldreturn [Object] 
  #
  #              Object to be used for sort order
  #
  def initialize( configuration_instance = nil, *args, & sort_object_block )
    
    super( configuration_instance, *args )

    @sort_object_block = sort_object_block if block_given?
    
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
    each_with_index do |this_object, index|
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
      @sort_block = block
    end

    each_with_index do |this_member, index|
      unless index + 1 == size
        sort_object = @sort_object_block ? @sort_object_block.call( this_member ) : this_member
        @sort_block.call( sort_object, self[ index + 1 ] )
      end
    end
    
    return self

  end

  ##############
  #  sort_by!  #
  ##############

  def sort_by!( & block )

    if block_given?
      @sort_object_block = block
    else
      return to_enum
    end
  
    each { |this_member| @sort_object_block.call( this_member ) }
    
    return self
    
  end

  ##############
  #  shuffle!  #
  ##############

  ###
  # Does not shuffle elements in self in place. Does nothing. Remains sorted.
  #
  def shuffle!( random_number_generator = nil )

    return self

  end
  
  ################################################
  #  perform_single_object_insert_between_hooks  #
  ################################################
  
  def perform_single_object_insert_between_hooks( index, object )

    perform_unsorted_insert( index = get_index_for_sorted_insert( object ), object )
    
    return index
    
  end
  
  ###############################
  #  perform_set_between_hooks  #
  ###############################

  def perform_set_between_hooks( index, object )

    delete_at( index ) unless index >= size
    
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
    
    element_count = size
    
    if object.nil?
      
      if @sort_order_reversed
        index = element_count
      elsif element_count > 0 and first.nil?
        index = rindex( nil ) + 1
      else
        index = 0
      end
    
    else

      each_with_index do |this_member, this_index|

        insert_sort_object = object
        existing_sort_object = this_member

        if @sort_object_block
          insert_sort_object = @sort_object_block.call( insert_sort_object )
          existing_sort_object = @sort_object_block.call( existing_sort_object )
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

      index = element_count unless index

    end
        
    return index
    
  end

end

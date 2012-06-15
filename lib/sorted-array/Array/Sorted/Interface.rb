
module ::Array::Sorted::Interface

  ################
  #  initialize  #
  ################

  # Adds optional block for retaining sort order.
  # @yield Block to use to determine sort order.
  def initialize( *args, & sort_object_block )
    
    super( *args )
    
    if block_given?
      @sort_object_block = sort_object_block
    end
    
  end
  
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

  ###############################
  #  perform_set_between_hooks  #
  ###############################

  def perform_set_between_hooks( index, object )

    unless index >= count
      delete_at( index )
    end
    
    return perform_insert_between_hooks( index, object )
    
  end
  
  ##################################
  #  perform_insert_between_hooks  #
  ##################################

  def perform_insert_between_hooks( index, *objects )

    # we ignore the index and insert in sorted order

    # we have to have at least one member for comparison-based insert (to retain sorted order)

    objects.each do |this_object|

      insert_occurred = false

      if this_object.nil?
        if @sort_order_reversed
          super( count, this_object )
        else
          super( 0, this_object )
        end
        next
      end
      
      self.each_with_index do |this_member, this_index|
        
        insert_sort_object = this_object
        existing_sort_object = this_member
        
        if @sort_object_block
          insert_sort_object = @sort_object_block.call( this_object )
          existing_sort_object = @sort_object_block.call( this_member )
        end
        
        if @sort_order_reversed
                    
          case insert_sort_object <=> existing_sort_object
            when 0, 1
              super( this_index, this_object )
              insert_occurred = true
              break
          end
          
        else
          
          case insert_sort_object <=> existing_sort_object
            when 0, -1
              super( this_index, this_object )
              insert_occurred = true
              break
          end
          
        end
        
      end
    
      unless insert_occurred
        super( count, this_object )
      end
      
    end

  end
  
end

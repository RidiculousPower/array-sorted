
require 'array/hooked'
#require_relative '../../../array-hooked/lib/array-hooked.rb'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

class ::Array::Sorted < ::Array::Hooked
  
  include ::Array::Sorted::ArrayInterface
    
end

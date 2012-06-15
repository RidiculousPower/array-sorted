
require 'hooked-array'

class ::Array::Sorted < ::Array::Hooked
end
class ::SortedArray < ::Array::Sorted
end

basepath = 'sorted-array/Array/Sorted'

files = [
  
  'Interface'
  
]

second_basepath = 'sorted-array/SortedArray'

second_files = [
  
  'Interface'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
second_files.each do |this_file|
  require_relative( File.join( second_basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
require_relative( second_basepath + '.rb' )

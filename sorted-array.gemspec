require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'sorted-array'
  spec.rubyforge_project         =  'sorted-array'
  spec.version                   =  '1.0.1'

  spec.summary                   =  "Provides Array::Sorted and SortedArray."
  spec.description               =  "A subclass of Array::Hooked that also keeps array sorted."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/sorted-array'

  spec.add_dependency            'hooked-array'

  spec.date                      = Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end

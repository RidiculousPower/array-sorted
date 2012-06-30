require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'array-sorted'
  spec.rubyforge_project         =  'array-sorted'
  spec.version                   =  '1.1.0'

  spec.summary                   =  "Provides Array::Sorted."
  spec.description               =  "A subclass of Array::Hooked that also keeps array sorted."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/array-sorted'

  spec.add_dependency            'array-hooked'

  spec.date                      = Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end

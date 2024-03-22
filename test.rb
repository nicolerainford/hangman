require 'yaml'

class Person
  attr_accessor :name

  def initialize(name:)
    @name = name
  end

  def info
    "Name: #{name}"
  end
end

a = Person.new(name: 'tim')

puts "person instance: #{a}"

yaml_string = a.to_yaml
puts "person instance as yaml string: #{yaml_string}"

#!/usr/bin/env ruby

# require lib folder
Dir['./lib/*.rb'].each {|file| require file }

# run the gen
template = ResumeTemplate.new('../ddavis_resume.json')
template.create_html
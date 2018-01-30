require "json"
require 'date'

class ResumeTemplate
  def initialize(json_file)
    file = File.read json_file 
    @resume = JSON.parse(file)
    @basic, @summary, @work, @education, @references, @skills, @publications = ""
  end

  def create_html
    run_methods = [self.basics, self.location, self.social_networks, self.work, self.education, self.skills, self.publications, self.references, self.summary]
    template = File.read './templates/template.html'
    template.gsub! '{{basics}}', @basic
    template.gsub! '{{summary}}', @summary
    template.gsub! '{{work}}', @work
    template.gsub! '{{education}}', @education
    template.gsub! '{{references}}', @references
    template.gsub! '{{skills}}', @skills
    template.gsub! '{{publications}}', @publications
    File.open('./generated/index.html', 'w') do |file|
      file.write(template)
    end
  end

  def basics
    basics_template = File.read "./templates/header.html"
    basics = @resume['basics']
    replace_tags = ['name', 'label', 'email', 'phone', 'picture', 'logo']
    replace_tags.each do |tag| 
      basics_template.gsub! "{{#{tag}}}", basics[tag]
    end 
    @basic = basics_template
  end 

  def location
    region = @resume['basics']['location']['region']
    @basic.gsub! '{{location}}', region
  end 

  def social_networks
    networks = @resume['basics']['profiles']
    html = "<ul>"
      networks.each do |media| 
        li_string = '<li> <a href="{{url}}"> {{network}} </a> </li>'
        html += li_string.gsub('{{url}}', media['url']).gsub('{{network}}', media['network'])
      end 
    html += "</ul>"

    @basic.gsub! '{{social}}', html
  end

  def skills
    html = ''
    skills = @resume['skills']
    skills.each do |skill| 
      template = File.read './templates/skills.html'
      name = skill['name']
      keywords = array_to_list(skill['keywords'])
      template.gsub! '{{name}}', name
      template.gsub! '{{keywords}}', keywords
      html << template
    end
    @skills = html
  end

  def publications
    html = ''
    replace_tags = ['name', 'website', 'publisher', 'releaseDate', 'summary']
    pubs = @resume['publications']
    pubs.each do |pub|
      template = File.read './templates/publications.html'
      replace_tags.each do |tag|
        template.gsub! "{{#{tag}}}", pub[tag]
      end
      html << template
    end
    @publications = html
  end

  def references
    html = ''
    replace_tags = ['name', 'reference']
    ref = @resume['references']
    ref.each do |r|
      template = File.read './templates/references.html'
      replace_tags.each do |tag| 
        template.gsub! "{{#{tag}}}", r[tag]
      end
      html << template
    end
    @references = html
  end

  def work
    html = ""
    replace_tags = ['company', 'position', 'website', 'startDate', 'endDate', 'summary', 'highlights']
    jobs = @resume['work']
    jobs.each do |job|
      template = File.read './templates/jobs.html'
      replace_tags.each do |tag|
        if tag == 'highlights'
          highlights = ''
          job[tag].each { |li| highlights += "<li> #{li} </li>"}
          template.gsub! "{{#{tag}}}", highlights
        elsif tag == 'startDate' || tag == 'endDate'
          fixed_date = job[tag] == 'present' ? 'Present' : convert_date(job[tag])
          template.gsub! "{{#{tag}}}", fixed_date
        else
          template.gsub! "{{#{tag}}}", job[tag]
        end
      end
      html += template
    end
    @work = html
  end

  def summary
    summary = @resume['basics']['summary']
    template = File.read './templates/summary.html' 
    template.gsub! '{{summary}}', summary 
    @summary = template
  end

  def education
    edu = @resume['education']
    replace_tags = ['institution', 'startDate', 'endDate', 'area', 'degree', 'summary']
    html = ''
    edu.each do |ed|
      template = File.read './templates/education.html' 
      replace_tags.each do |tag|
        template.gsub! "{{#{tag}}}", ed[tag]
      end 
      html += template
    end 
    @education = html
  end

  def convert_date(date_to_convert)
    date = Date.parse(date_to_convert)
    date.strftime('%B %Y')
  end

  def array_to_list(arry)
    arry.sort!
    tmp_html = ""
    arry.each do |item|
      tmp_html << "<li> #{item} </li>"
    end 
    tmp_html
  end 
end
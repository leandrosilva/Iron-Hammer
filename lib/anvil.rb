require File.dirname(__FILE__) + '/solution'
require File.dirname(__FILE__) + '/solution_file'
require File.dirname(__FILE__) + '/the_filer'
require File.dirname(__FILE__) + '/project_factory'

class Anvil
  attr_accessor :solution
  attr_accessor :projects

  def initialize params={}
    @solution = params[:solution]
    @projects = params[:projects]
  end

  def load_projects_from_solution
    @projects = @projects || []
    @solution.file.projects.each do |p|
      @projects << ProjectFactory::create(p.merge(
        :type => ProjectFile.type_of(@solution.path, path = p[:path], csproj = p[:csproj])
      ))
    end
  end

  def self.load *path
    pattern = File.join path, '*.sln'
    entries = Dir[pattern]
    unless entries.nil? || entries.empty?
      Anvil.new(
        :solution => Solution.new(
          :name => entries.first.split('/').pop.sub('.sln', ''),
          :file => SolutionFile.parse_file(entries.first)
        )
      ) 
    end
  end
end unless defined? Anvil

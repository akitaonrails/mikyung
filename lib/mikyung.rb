class HasRelation
  def initialize(rel)
    @rel = rel
  end
  
  def matches?(resource)
    resource.respond_to?(@rel)
  end
end

class RelationDrivenObjective

  def self.executes(what, options = {})
    internals << [options[:when], what]
  end
  
  def self.has_relation?(rel)
    HasRelation.new(rel)
  end
  
  def internals
    self.class.internals
  end
  
  def next_step(resource)
    step = internals.find do |k|
      k.first.matches?(resource)
    end
    step ? step.last : nil    
  end

  private

  def self.internals
    @steps ||= []
  end

end


# iterates following a series of steps provided a goal and a starting uri.
#
# Mikyung.new(objective).run(uri)
class Mikyung
  
  # initializes with a goal in mind
  def initialize(goal)
    @goal = goal
  end

  # keeps changing from a steady state to another until its goal has been achieved
  def run(uri)
    
    current = Restfulie.at(uri).get
    Restfulie::Common::Logger.logger.debug current.response.body
    
    while(!@goal.completed?(current))
      step = @goal.next_step(current)
      raise "No step was found for #{current} with links #{current.links}" unless step
      Restfulie::Common::Logger.logger.debug "Mikyung > next step will be #{step}"
      step = step.new if step.kind_of? Class
      current = try_to_execute(step, current, 3)
    end
    
  end

  private
  
  def try_to_execute(step, current, max_attempts)
    raise "Unable to proceed when trying to #{step}" if max_attempts == 0

    resource = step.execute(current)
    if resource==nil
      raise "Step returned 'give up'"
    end
    if resource.response.code != 200
      try_to_execute(step, max_attempts - 1)
    else
      Restfulie::Common::Logger.logger.debug resource.response.body
      resource
    end
  end

  def direct_execute(step, current, max_attempts)
    step.execute(current)
  end
end

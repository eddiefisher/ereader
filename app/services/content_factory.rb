Dir[File.dirname(__FILE__) + '/content_filters/*.rb'].each { |file| require file }

class ContentFactory
  attr_reader :filter, :result

  def initialize(source, filter = [])
    @filter = filter
    @source = source
    execute
  end

  def execute
    @result = @source
    filter.each do |f|
      @result = executed_filter(f).execute(@result)
    end
    @result
  end

  private

  def executed_filter(filter)
    class_name = filter.to_s.capitalize
    if class_exists?(class_name)
      class_name.constantize.new
    else
      fail "Unknow type: #{class_name}"
    end
  end

  def class_exists?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end
end

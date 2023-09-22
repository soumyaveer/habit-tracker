class Presenter
  attr_reader :obj, :type

  def initialize(obj, type)
    @obj = obj
    @type = type 
  end

  def present_errors
    {
      "type": type,
      "attributes": {
        errors: obj[:errors]
      }
    }
  end

  def present_resource 
    {
      "type": obj.class,
      "id": obj.id,
      "attributes": obj
    }
  end
end
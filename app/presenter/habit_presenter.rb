require_relative './presenter'
class HabitPresenter < Presenter
  attr_reader :obj, :type, :relationship_obj, :relationship_type, :obj_collection, :links_metadata, :users_json
  
  def initialize(
    object: nil, 
    type: nil, 
    relationship_obj: nil,
    relationship_type: nil, 
    obj_collection: [], 
    links_metadata: {},
    users_json: {}
  )
    @obj = object
    @type = type
    @relationship_obj = relationship_obj
    @relationship_type = relationship_type 
    @obj_collection = obj_collection
    @links_metadata = links_metadata
    @users_json = users_json
  end

  def present_user
    return present_resource if relationship_obj.blank?

    present_resource.merge!(relationship)
  end

  def present_users
    users_json.merge!(metadata).merge!(links)
  end

  private 
  
  def relationship
    {
      "relationships": {
        "#{relationship_type}":{
          "data": {
            "type": relationship_obj.class,
            "id": relationship_obj.id,
          }
        }
      }
    }.as_json
  end

  def metadata
    {
      meta: {
        totalPages: obj_collection.total_pages
      }
    }.as_json
  end

  def links
    {
      links: links_metadata
    }.as_json
  end
end
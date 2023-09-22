require_relative './presenter'
class HabitPresenter < Presenter
  attr_reader :obj, :type, :relationship_obj, :relationship_type
  def initialize(object:, type:, relationship_obj: nil, relationship_type: nil)
    @obj = object
    @type = type
    @relationship_obj = relationship_obj
    @relationship_type = relationship_type 
  end

  def present
    return present_resource.merge(relationship) if relationship_obj.present?
    present_resource
  end

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

  def metadata(obj)
    {
      meta: {
        totalPages: obj&.total_pages || 0
      }
    }.as_json
  end

  def links(obj)
    {
      links: {
        self: request.url,
        first: first_page_url,
        prev: prev_page_url,
        next: next_page_url,
        last: last_page_url(obj)
      }
    }.as_json
  end

  def first_page_url
    new_page = Habit.page(1).current_page
    build_query_string(new_page)
  end

  def prev_page_url
    new_page = Habit.page(page_number).per(page_size).prev_page
    build_query_string(new_page)
  end

  def next_page_url
    new_page = Habit.page(page_number).per(page_size).next_page
    build_query_string(new_page)
  end

  def last_page_url(obj)
    new_page = Habit.page(obj.total_pages).current_page
    build_query_string(new_page)
  end

  def build_query_string(new_page)
    current_page_number = request.params['page']['number']
    query_string = request.query_string.gsub("page[number]=#{current_page_number}", "page[number]=#{new_page}")
    request.base_url + request.path + "?" + query_string
  end
end
class SqlRepository
  attr_reader :table, :entity, :pool

  def initialize(pool: -> { ApplicationRecord.connection }, entity: default_entity, table: default_entity)
    @pool = pool
    @table = table
    @entity = entity
  end

  def fetch(id, name:)
    return if id.blank?

    rel = table.project(*default_columns)
    rel.where(table[:id].eq(id))
    query(rel.take(1).to_sql, name: name)&.first
  end

  protected

  def query(sql, name:)
    result = execute(sql, name: name)
    result.empty? ? nil : result.map { |row| load(row.to_h) }
  end

  def execute(sql, name:)
    with_connection do |connection|
      connection.exec_query(sql, name)
    end
  end

  def with_connection(connection: pool)
    yield connection.call
  end
end

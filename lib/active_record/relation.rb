class ActiveRecord::Relation < Object
  ##
  # Replace query with simple counting via database instead of counting in codes.
  def empty?
    count == 0
  end
end
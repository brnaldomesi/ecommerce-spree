module ActiveRecord
  module RelationExtension
    ##
    # Replace query with simple counting via database instead of counting in codes.
    def empty?
      count == 0
    end
  end
end

ActiveRecord::Relation.class_eval { include ActiveRecord::RelationExtension }
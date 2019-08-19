# frozen_string_literal: true

json.(taxonomy, :id, :name )
json.root do
  json.(taxonomy.root, :id, :name, :pretty_name, :permalink, :parent_id, :taxonomy_id)
  json.taxons(taxonomy.root.children) do |taxon|
    json.(taxon, :id, :name, :pretty_name, :permalink, :parent_id, :taxonomy_id )
    json.partial!("spree/api/taxons/taxons", taxon: taxon)
  end
end

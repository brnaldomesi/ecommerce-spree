# frozen_string_literal: true

json.taxons(taxon.children) do |taxon|
  json.(taxon, :id, :name, :pretty_name, :permalink, :parent_id, :taxonomy_id)
  json.partial!('spree/api/taxons/taxons', taxon: taxon)
end

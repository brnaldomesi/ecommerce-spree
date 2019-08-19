# frozen_string_literal: true

if params[:set] == 'nested'
  json.partial!('spree/api/taxonomies/nested', taxonomy: taxonomy)
else
  json.(taxonomy, :id, :name)
  json.root do
    json.(taxonomy.root, :id, :name, :pretty_name, :permalink, :parent_id, :taxonomy_id)
    json.taxons(taxonomy.root.children) do |taxon|
      json.(taxon, :id, :name, :pretty_name, :permalink, :parent_id, :taxonomy_id)
    end
  end
end

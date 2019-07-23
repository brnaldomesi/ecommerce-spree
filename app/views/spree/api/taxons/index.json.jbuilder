json.partial! 'spree/api/shared/pagination', pagination: @taxons
json.taxons(@taxons) do |taxon|
  json.(taxon, :id, :name, :pretty_name, :permalink, :parent_id, :taxonomy_id )
  unless params[:without_children]
    json.partial!('spree/api/taxons/taxons', taxon: taxon)
  end
end

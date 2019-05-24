module SiteCategoriesHelper

  def list_item_for_mapping(cat)
    html = cat.name
    icon_subclass = cat.mapped_taxon_id ? 'check' : 'bars'
    html += button_tag(class: 'btn btn-sm btn-light') do
      link_to(site_category_path(cat, format:'js'), remote: true ) do
        content_tag('i', id: "map_site_category_button_#{cat.id}", class: 'fas fa-' + icon_subclass) { }.html_safe
      end.html_safe
    end
    html
  end

  def category_taxon_selector(site_category, category_taxon)
    content_tag(:div, class: 'card card-body') do
      concat( form_for(site_category, remote: true, method: :put, html:{ class:'form' } ) do|f|
        concat f.hidden_field(:mapped_taxon_id, value: category_taxon.id)
        concat( content_tag(:div, class:'input-group') do
          submit_tag(category_taxon.name, class:'btn btn-category' + (site_category.mapped_taxon_id == category_taxon.id ? ' btn-secondary' : '')) +
          content_tag(:div, class:'input-group-append') do
            button_tag(' ', type:'button', class:'btn btn-light dropdown-toggle', 'data-toggle' => 'collapse', 'data-target' => "#children_categories_#{category_taxon.id}", 'aria-expanded' => 'false', 'aria-controls'=>'')
          end
        end )
      end )
      concat( content_tag(:div, class:'collapse', id: "children_categories_#{category_taxon.id}") do
        category_taxon.children.each do|child_cat|
          concat category_taxon_selector(site_category, child_cat)
        end # category_taxon.children.each
      end )
    end # card
  end
end
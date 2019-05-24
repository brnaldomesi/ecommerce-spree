class SiteCategoriesController < ::InheritedResources::Base
  helper 'spree/admin/navigation'
  layout 'minimal'

  before_action :authorize_admin

  before_action :update_recent_categories, only: [:update, :show, :index]

  def index
    logger.info "| SiteCategory params #{params}"
    params.permit!
    @site_categories = SiteCategory.where(depth: 1).order('position asc')
    @site_categories = @site_categories.where(site_name: params[:site_name] ) if params[:site_name].present?
    respond_to do|format|
      format.html
    end
  end

  def show
    super do|format|
      format.js
    end
  end

  def update
    super do|format|
      format.js
    end
  end

  def site_category_params
    params.require(:site_category).permit(:site_name, :name, :other_site_category_id, :parent_id, :mapped_taxon_id, :position, :depth)
  end

  private

  def update_recent_categories
    @recently_mapped_category_taxon_ids = session[:recently_mapped_category_taxon_ids] || []
    taxon_id = params[:site_category].try(:[], :mapped_taxon_id)
    if taxon_id
      @recently_mapped_category_taxon_ids.insert(0, taxon_id.to_i)
      @recently_mapped_category_taxon_ids.uniq!
      @recently_mapped_category_taxon_ids.slice!(10, @recently_mapped_category_taxon_ids.size - 10)
      session[:recently_mapped_category_taxon_ids] = @recently_mapped_category_taxon_ids
    end
  end
end
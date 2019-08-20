Spree::Admin::ResourceController.class_eval do
  def update_positions
    model_class.transaction do
      params[:positions].each do |id, index|
        next unless ( id.is_a?(Integer) || id.to_s =~ /\A\d+\Z/ )
        model_class.find(id).set_list_position(index)
      end
    end

    respond_to do |format|
      format.js { head :no_content }
    end
  end
end
class Admin::GatewaysController < Admin::BaseController
  resource_controller
  before_filter :load_data

  update.before do
		if params[:gateway] && params[:gateway][:type] && @object.type.to_s != params[:gateway][:type]
			@object.type = params[:gateway][:type]
			@object.save
			
			load_object			
		end
 		@object.update_attributes params[@object.class.name.underscore.gsub("/", "_")]
  end

  update.wants.html { redirect_to edit_object_url }
  create.wants.html { redirect_to edit_object_url }

  private       
  def build_object
		if params[:gateway] && params[:gateway][:type]
			@object ||= params[:gateway][:type].constantize.send parent? ? :build : :new, object_params 
		else
			@object ||= end_of_association_chain.send parent? ? :build : :new, object_params 
		end
  end
  
  def load_data   
    @providers = Gateway.providers
  end
end

ActiveAdmin.register Domain do
permit_params :domain, :city, :state, :keywords
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  

  # page_action :edit, method: :get do
  #   within @head do
  #     script :src => javascript_path('custom.js'), :type => "text/javascript"
  #   end
  # end
  form do |f|
    f.inputs "Domains" do
      f.input :domain
      f.input :city
      f.input :state
      f.input :keywords
    end
    f.actions
    render :partial => "form"
  end
end

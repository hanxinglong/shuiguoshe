class Cpanel::ApplicationController < ApplicationController
  
  before_filter :require_user
  before_filter :require_admin
  
  layout 'cpanel'
  
  def require_admin
    unless current_user.admin?
      render_404
    end
  end
end
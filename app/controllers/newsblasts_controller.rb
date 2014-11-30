class NewsblastsController < ApplicationController
  before_action :set_newsblast, only: [:show]

  def show
    
  end

  private
    def set_newsblast
      @newsblast = Newsblast.find(params[:id])
    end
    
end

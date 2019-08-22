class Api::V0::ArticlesController < ApplicationController
  before_action :authenticate_api_v0_user!, only: [:create]
  
  def index
    articles = Article.all
    render json: articles, each_serializer: Articles::IndexSerializer
  end

  def create
    if current_api_v0_user.research_group?
      Article.create(article_params.merge(author: current_api_v0_user))
      render json: { message: 'Article successfully created.' } 
    else
      render json: { error: 'Current user has no permission to create article.' }, status: 422
    end

  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
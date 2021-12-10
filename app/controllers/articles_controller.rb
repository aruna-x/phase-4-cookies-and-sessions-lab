class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session_views = session[:page_views]
    if (session_views) then
      if (session_views >= 3) then
        render json: {error: "Please sign up to view more."}, status: :unauthorized
      end
      session[:page_views] += 1
    else 
      session[:page_views] ||= 0
    end

    # p session_views

    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

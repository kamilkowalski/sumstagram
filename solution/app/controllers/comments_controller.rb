class CommentsController < ApplicationController
  def index
    limit = params.fetch(:limit, 25)
    offset = params.fetch(:offset, 0)
    
    comments = current_photo.comments.limit(limit).offset(offset).order(created_at: :asc)
    
    render json: comments
  end

  def create
    comment_params = params.permit(:content).merge(user: current_token_user)
    comment = current_photo.comments.build(comment_params)
    
    if comment.valid?
      comment.save
      render nothing: true, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :bad_request
    end
  end
  
  private
  
  def current_photo
    @current_photo ||= Photo.find(params[:photo_id])
  end
end

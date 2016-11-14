class CommentsController < ApplicationController
  def index
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

class PhotosController < ApplicationController
  def index
    limit = params.fetch(:limit, 25)
    offset = params.fetch(:offset, 0)
    
    photos = Photo.limit(limit).offset(offset)
    
    render json: photos
  end

  def create
    photo = current_token_user.photos.build(image: params[:encoded_image])
    comment = current_token_user.comments.build(photo: photo, content: params[:comment])

    if photo.valid? && comment.valid?
      photo.save
      comment.save
      render nothing: true, status: :created
    else
      error_messages = photo.errors.full_messages + comment.errors.full_messages
      render json: { errors: error_messages }, status: :bad_request
    end
  end
end

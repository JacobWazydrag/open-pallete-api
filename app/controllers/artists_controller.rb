class ArtistsController < ApplicationController

    def secret 
        ENV["HS256"]
    end

    def index
        @artists = Artist.all
        render json: @artists
    end

    def show
        artist = Artist.find(params[:id])
        render json: artist
    end

    def create
        artist = Artist.create(artist_params)
        if artist.valid?
            token = JWT.encode({artist_id: artist.id}, secret, 'HS256')
            render json: {artist: artist, token: token}
        else
            render json: {errors: artist.errors.full_messages}
        end
    end

    def update
        artist = Artist.find(params[:id])
        artist.update(artist_params)
        render json: artist
    end

    def destroy
        artist = Artist.find(params[:id])
        artist.destroy
    end

    private

    def artist_params
        params.permit(:username, :first_name, :last_name, :email, :bio, :profile_photo, :password, :instagram_url, :facebook_url, :phone_number)
    end

end
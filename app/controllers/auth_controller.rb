class AuthController < ApplicationController
    
    def secret 
        ENV["HS256"]
    end

    def login
        student = Student.find_by(username: login_params[:username])
        artist = Artist.find_by(username: artist_login_params[:username])
        if student && student.authenticate(login_params[:password])
             token = JWT.encode({student_id: student.id}, secret, 'HS256')
            render json: {student: student, token: token}
        elsif artist && artist.authenticate(artist_login_params[:password])
            token = JWT.encode({artist_id: artist.id}, secret, 'HS256')
            render json: {artist: artist, token: token}
        else
            render json: {errors: artist.errors.full_messages}
        end
    end

    def persist
        if request.headers['Authorization']
            encoded_token = request.headers['Authorization'].split(' ')[1]
            token = JWT.decode(encoded_token, secret)
            student_id = token[0]['student_id']
            student = Student.find(student_id)
            render json: student
        
        elsif request.headers['Authorization']
        encoded_token = request.headers['Authorization'].split(' ')[1]
        token = JWT.decode(encoded_token, secret)
        artist_id = token[0]['artist_id']
        artist = Artist.find(artist_id)
        render json: artist
        end
    end


    private

        def login_params
        params.require(:auth).permit(:username, :password, :auth)
        end

        def artist_login_params
            params.require(:auth).permit(:username, :password, :auth)
        end
end
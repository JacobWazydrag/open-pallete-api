class StudentsController < ApplicationController

    def secret 
        ENV["HS256"]
    end

    def index
        @students = Student.all
        render json: @students
    end

    def show
        student = Student.find(params[:id])
        render json: student
    end

    def create
        student = Student.create(student_params)
        if student.valid?
            token = JWT.encode({student_id: student.id}, secret, 'HS256')
            render json: {student: student, token: token}
        else
            render json: {errors: student.errors.full_messages}
        end
    end

    def update
        student = Student.find(params[:id])
        student.update(student_params)
        render json: student
    end

    def destroy
        student = Student.find(params[:id])
        student.destroy
    end

    private

    def student_params
        params.permit(:username, :first_name, :last_name, :email, :bio, :profile_photo, :password, :student)
    end

end
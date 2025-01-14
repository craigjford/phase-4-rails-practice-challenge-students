class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    wrap_parameters format: []

    def index 
        students = Student.all
        render json: students, include: :instructor, status: :ok                  
    end

    def show    
        student = find_student
        render json: student, status: :ok
    end

    def create 
        instructor = Instructor.find_by(id: params[:instructor_id]) 
        if instructor
            student = instructor.students.create!(student_params)
            render json: student, status: :created
        else
            render json: { error: "Instructor not found" }, status: :not_found
        end                   
    end

    def update 
        instructor = Instructor.find_by(id: params[:instructor_id]) 
        if instructor
            student = find_student
            student.update!(student_params)
            render json: student, include: :instructor, status: :accepted
        else
            render json: { error: "Instructor not found" }, status: :not_found
        end                         
    end

    def destroy 
        student = find_student  
        student.destroy
        head :no_content, status: 204
    end

    private

    def find_student   
        Student.find(params[:id])
    end

    def student_params
        params.permit(:name, :major, :age)
    end

    def render_not_found_response
      render json: { error: "Student not found" }, status: :not_found
    end
  
    def render_unprocessable_entity_response(invalid)  
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end

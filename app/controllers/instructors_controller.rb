class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    wrap_parameters format: []

    def index        
        instructors = Instructor.all  
        render json: instructors, include: :students, status: :ok
    end

    def show    
        instructor = find_instructor
        render json: instructor, status: :ok
    end

    def update   
        instructor = find_instructor
        instructor.update!(instructor_params)
        render json: instructor, status: :accepted
    end

    def create   
        instructor = Instructor.create!(instructor_params)
        render json: instructor, status: :created
    end

    def destroy 
        instructor = find_instructor  
        instructor.destroy
        head :no_content, status: 204
    end

    private

    def find_instructor   
        Instructor.find(params[:id])
    end

    def instructor_params
        params.require(:instructor).permit(:name)
      end

    def render_not_found_response
      render json: { error: "Instructor not found" }, status: :not_found
    end
  
    def render_unprocessable_entity_response(invalid)  
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end

class StudentCommentsController < ApplicationController
  before_action :set_student, only: [:new]
  before_action :set_student_comment, only: [:edit, :update, :destroy]
  before_action :set_student_of_comment, only: [:edit, :destroy]

  add_breadcrumb 'Home', :root_path

  def new
    add_breadcrumb 'Students', students_path
    add_breadcrumb @student.name, student_path(@student)
    add_breadcrumb 'New Student Comment'

    @student_comment = StudentComment.new
  end

  def create
    @student_comment = StudentComment.new(student_comment_params)

    if @student_comment.save
      redirect_to student_path(student_comment_params[:student_id])
    else
      @student = Student.of(current_user)
                        .find(student_comment_params[:student_id])
      render :new
    end
  end

  def edit
    add_breadcrumb 'Students', students_path
    add_breadcrumb @student.name, student_path(@student)
    add_breadcrumb 'Edit Comment'
  end

  def update
    if @student_comment.update(student_comment_params)
      redirect_to student_path(student_comment_params[:student_id])
    else
      @student = Student.of(current_user)
                        .find(student_comment_params[:student_id])
      render :edit
    end
  end

  def destroy
    @student_comment.destroy

    redirect_to student_path(@student)
  end

  private

  def student_comment_params
    params.require(:student_comment).permit(
      :content,
      :student_id
    )
  end

  def set_student
    @student = Student.of(current_user).find(params[:student])
  rescue ActiveRecord::RecordNotFound
    deny_access
  end

  def set_student_of_comment
    @student = Student.of(current_user).find(@student_comment.student_id)
  rescue ActiveRecord::RecordNotFound
    deny_access
  end

  def set_student_comment
    @student_comment = StudentComment.find(params[:id])
  end
end

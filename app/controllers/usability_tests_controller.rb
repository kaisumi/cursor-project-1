class UsabilityTestsController < ApplicationController
  before_action :require_admin, except: [:participate, :submit_feedback]
  
  def index
    @tests = UsabilityTest.all
  end
  
  def new
    @test = UsabilityTest.new
  end
  
  def create
    @test = UsabilityTest.new(usability_test_params)
    
    if @test.save
      redirect_to usability_tests_path, notice: "テストが作成されました"
    else
      render :new
    end
  end
  
  def show
    @test = UsabilityTest.find(params[:id])
    @results = @test.usability_test_results
  end
  
  def participate
    @test = UsabilityTest.find_by(token: params[:token])
    
    if @test.nil?
      redirect_to root_path, alert: "テストが見つかりません"
    end
  end
  
  def submit_feedback
    @test = UsabilityTest.find_by(token: params[:token])
    
    if @test.nil?
      redirect_to root_path, alert: "テストが見つかりません"
      return
    end
    
    @result = @test.usability_test_results.new(
      user: current_user,
      completion_time: params[:completion_time],
      success: params[:success],
      difficulty_rating: params[:difficulty_rating],
      feedback: params[:feedback]
    )
    
    if @result.save
      redirect_to root_path, notice: "フィードバックをありがとうございます"
    else
      render :participate
    end
  end
  
  private
  
  def usability_test_params
    params.require(:usability_test).permit(:title, :description, :task, :token)
  end
  
  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "権限がありません"
    end
  end
end

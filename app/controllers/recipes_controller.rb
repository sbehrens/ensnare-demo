class RecipesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = Comment.new
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(params[:recipe])
    if @recipe.save
      redirect_to @recipe, notice: "Recipe was created."
    else
      render :new
    end
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
    if(@recipe.blank)
    AppTrap::Violation.create(:ip_address=>request.remote_ip.to_s,
        :violation_type=>"Authorization Violation",
        :session_id=>session.try(:[],"session_id").to_s,
        :user_id=>current_user.id,
        :expected=>"",
        :name=>"recipe#edit",
        :observed=>params[:id].to_s,
        :weight=>5)

    end
  end

  def update
    @recipe = current_user.recipes.find(params[:id])
    if(@recipe.blank)
    AppTrap::Violation.create(:ip_address=>request.remote_ip.to_s,
        :violation_type=>"Authorization Violation",
        :session_id=>session.try(:[],"session_id").to_s,
        :user_id=>current_user.id,
        :expected=>"",
        :name=>"recipe#update",
        :observed=>params[:id].to_s,
        :weight=>5)
  end
    if @recipe.update_attributes(params[:recipe])
      redirect_to @recipe, notice: "Recipe was updated."
    else
      render :edit
    end
  end

  def destroy
    @recipe = current_user.recipes.find(params[:id])
    puts @recipe
    if(@recipe.blank)
      puts "\n\n\nIN HERE\n\n\n"
    AppTrap::Violation.create(:ip_address=>request.remote_ip.to_s,
        :violation_type=>"Authorization Violation",
        :session_id=>session.try(:[],"session_id").to_s,
        :user_id=>current_user.id,
        :expected=>"",
        :name=>"comments#destory",
        :observed=>params[:id].to_s,
        :weight=>5)
  end
    @recipe.destroy
    redirect_to recipes_url, notice: "Recipe was destroyed."
  end
end

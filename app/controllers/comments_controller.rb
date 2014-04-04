class CommentsController < ApplicationController
  before_filter :require_login
  before_filter :load_recipe

  def create
    @comment = @recipe.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      @comment.create_activity :create, owner: current_user
      redirect_to @recipe, notice: "Comment was created."
    else
      render :new
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
    if(@comment.blank)
    AppTrap::Violation.create(:ip_address=>request.remote_ip.to_s,
        :violation_type=>"Authorization Violation",
        :session_id=>session.try(:[],"session_id").to_s,
        :user_id=>current_user.id,
        :expected=>"",
        :name=>"comments#edit",
        :observed=>params[:id].to_s,
        :weight=>5)
  end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if(@comment.blank)
    AppTrap::Violation.create(:ip_address=>request.remote_ip.to_s,
        :violation_type=>"Authorization Violation",
        :session_id=>session.try(:[],"session_id").to_s,
        :user_id=>current_user.id,
        :expected=>"",
        :name=>"comments#update",
        :observed=>params[:id].to_s,
        :weight=>5)
    end
    if @comment.update_attributes(params[:comment])
      redirect_to @recipe, notice: "Comment was updated."
    else
      render :edit
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if(@comment.blank)
    AppTrap::Violation.create(:ip_address=>request.remote_ip.to_s,
        :violation_type=>"Authorization Violation",
        :session_id=>session.try(:[],"session_id").to_s,
        :user_id=>current_user.id,
        :expected=>"",
        :name=>"comments#delete",
        :observed=>params[:id].to_s,
        :weight=>5)
     end
    @comment.destroy
    @comment.create_activity :destroy, owner: current_user
    redirect_to @recipe, notice: "Comment was destroyed."
  end

private

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end

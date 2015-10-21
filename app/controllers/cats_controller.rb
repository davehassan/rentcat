class CatsController < ApplicationController

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      render :show
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      render :show
    else
      render :new
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy
    render :index
  end

  private
    def cat_params
      params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
    end
end

class HomeController < ApplicationController
  before_action:set_locale

  def set_locale
    I18n.locale = session[:lang]
  end
  def index
    session[:lang] ||= 'en'
    set_locale
    @tags = Tag.order(count: :desc).limit(5)
    @items = Item.order(created_at: :desc).limit(5)
    @collections = Collection.order(items_count: :desc).limit(5)
    @item_Owners = []
    @items.each do |item|
      @item_Owners << User.find_by(id: item.owner_id).name
    end
    @collection_Owners = []
    @collections.each do |collection|
      @collection_Owners << User.find_by(id: collection.owner_id).name
    end

  end

  def change_language
    session[:lang] = params[:lang]
    set_locale
    redirect_to request.referer
  end

  def items_listing
    @Items = Item.all
    @Owners = []
    @Items.each do |item|
      @Owners << User.find_by(id: item.owner_id).name
    end
  end

  def collections_listing
    @Collections = Collection.all
    @Owners = []
    @Collections.each do |collection|
      @Owners << User.find_by(id: collection.owner_id).name
    end
  end

  def view_item

  end

  def view_collection

  end

  def search_results
    @tags = Tag.order(count: :desc).limit(5)
    if params[:tag_search]
      tag = params[:format]
      @items = Item.where("tags LIKE ?", "%#{tag}%")
      @Owners = []
      @items.each do |item|
        @Owners << User.find_by(id: item.owner_id).name
      end
    end
  end
end

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
    @item = Item.find_by(id: params[:format])
    if @item.collection_id != "NA"
      @collection_name = Collection.find_by(id: @item.collection_id).name
      @fields = CustomField.where(collection_id: @item.collection_id)
      @field_values = []
      @fields.each do |field|
        @field_values << CustomFieldValue.find_by(item_id: @item.id, field_id: field.id).value
      end
    else
      @collection_name = "NA"
    end
    @owner_name = User.find_by(id: @item.owner_id).name
    @likes = Vote.where(type_name: 'item', type_id: @item.id, action: 'like').count
    if @likes.nil?
      @likes = 0
    end

    @dislikes = Vote.where(type_name: 'item', type_id: @item.id, action: 'dislike').count
    if @dislikes.nil?
      @dislikes = 0
    end

    @vote = Vote.find_by(type_name: 'item', type_id: @item.id, user_id: current_user.id)
    if @vote.nil?
      @liked = 0
    elsif @vote.action == 'like'
      @liked = 1
    else
      @liked = 2
    end

    @comments = Comment.where(type_name: 'item', type_id: @item.id)
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

  def vote
    @vote = Vote.find_by(type_name: params[:type], type_id: params[:type_id], user_id: current_user.id)
    if @vote.nil?
      @vote = Vote.create(type_name: params[:type], type_id: params[:type_id], action: params[:action_name], user_id: current_user.id)
    elsif @vote.action == params[:action_name]
      @vote.destroy
    else
      @vote.update(action: params[:action_name])
    end
    redirect_to request.referer
  end

  def comment

  end
end

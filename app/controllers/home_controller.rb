class HomeController < ApplicationController
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

    if user_signed_in?
      @vote = Vote.find_by(type_name: 'item', type_id: @item.id, user_id: current_user.id)
      if @vote.nil?
        @liked = 0
      elsif @vote.action == 'like'
        @liked = 1
      else
        @liked = 2
      end
    else
      @liked = 0
    end

    @comments = Comment.where(type_name: 'item', type_id: @item.id)
  end

  def view_collection
    @collection = Collection.find_by(id: params[:format])
    @items = Item.where(collection_id: @collection.id)
    @items_count = @items.count
    @fields = CustomField.where(collection_id: @collection.id)
    @owner_name = User.find_by(id: @collection.owner_id).name
    @likes = Vote.where(type_name: 'collection', type_id: @collection.id, action: 'like').count
    if @likes.nil?
      @likes = 0
    end

    @dislikes = Vote.where(type_name: 'collection', type_id: @collection.id, action: 'dislike').count
    if @dislikes.nil?
      @dislikes = 0
    end

    if user_signed_in?
      @vote = Vote.find_by(type_name: 'collection', type_id: @collection.id, user_id: current_user.id)
      if @vote.nil?
        @liked = 0
      elsif @vote.action == 'like'
        @liked = 1
      else
        @liked = 2
      end
    end

    @comments = Comment.where(type_name: 'collection', type_id: @collection.id)
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
      @collections = []
    elsif params[:search]
      text = params[:search_string]
      @items = []
      @collections = []

      temp_items = Item.where("name LIKE ?", "%#{text}%")
      temp_items_tag = Item.where("tags LIKE ?", "%#{text}%")
      temp_collections = Collection.where("name LIKE ?", "%#{text}%")
      temp_collections_desc = Collection.where("description LIKE ?", "%#{text}%")
      temp_collections_cate = Collection.where("category LIKE ?", "%#{text}%")
      users = User.where("name LIKE ?", "%#{text}%")

      @comments = Comment.where("content LIKE ?", "%#{text}%")

      users.each do |user|
        if Item.where(owner_id: user.id)
          temp_items_owner = Item.where(owner_id: user.id)
          temp_items_owner.each do |item|
            @items << item
          end
        end
        if Collection.where(owner_id: user.id)
          temp_collections_owner = Collection.where(owner_id: user.id)
          temp_collections_owner.each do |collection|
            @collections << collection
          end
        end
      end
      temp_items.each do |item|
        @items << item
      end
      temp_items_tag.each do |item|
        @items << item
      end
      temp_collections.each do |collection|
        @collections << collection
      end
      temp_collections_desc.each do |collection|
        @collections << collection
      end
      temp_collections_cate.each do |collection|
        @collections << collection
      end

      @comments.each do |comment|
        if comment.type_name == "item"
          @items << Item.find_by(id: comment.type_id)
        elsif comment.type_name == "collection"
          @collections << Collection.find_by(id: comment.type_id)
        end
      end

      @Owners = []
      @items.each do |item|
        @Owners << User.find_by(id: item.owner_id).name
      end
      @Owners_collections = []
      @collections.each do |collection|
        @Owners_collections << User.find_by(id: collection.owner_id).name
      end
    end

  end

  def vote
    if valid_user
      @vote = Vote.find_by(type_name: params[:type], type_id: params[:type_id], user_id: current_user.id)
      if @vote.nil?
        @vote = Vote.create(type_name: params[:type], type_id: params[:type_id], action: params[:action_name], user_id: current_user.id)
      elsif @vote.action == params[:action_name]
        @vote.destroy
      else
        @vote.update(action: params[:action_name])
      end
      redirect_to request.referer
    else
      redirect_to new_user_session_path
    end
  end

  def comment
    if valid_user
      @comment = Comment.create(content: params[:comment], type_name: params[:type_name], type_id: params[:type_id], user_id: current_user.id, user_name: current_user.name)
      @comment.save

      redirect_to request.referer
    else
      redirect_to new_user_session_path
    end

  end

  private

  def valid_user
    if user_signed_in? && current_user.status != "blocked"
      return true
    else
      return false
    end
  end
end

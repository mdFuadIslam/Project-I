class UsersController < ApplicationController
  before_action :valid_user

  def admin_page
    if valid_admin
      @users = User.unscoped.all
    end
  end

  def settings
  end

  def manage
    selected_user_ids = params[:user_ids]

    if params[:block]
      User.unscoped.where(id: selected_user_ids).update_all(status: "blocked")
    elsif params[:delete]
      User.unscoped.where(id: selected_user_ids).destroy_all
    elsif params[:unblock]
      User.unscoped.where(id: selected_user_ids).update_all(status: "member")
    elsif params[:add_to_admin]
      User.unscoped.where(id: selected_user_ids).update_all(status: "admin")
    elsif params[:remove_from_admin]
      User.unscoped.where(id: selected_user_ids).update_all(status: "member")
    end

    flash[:notice] = "Action was successful!"
    redirect_to request.referer
  end

  def admin_user_view
    if valid_admin
      @user = User.find_by(id: params[:format])
      unless @user
        redirect_to users_admin_page_path
      end
    end
  end

  def collections_management
    @total = 0
    @collections = Collection.where(owner_id: current_user.id)
    if @collections.nil?
      @collections = []
    else
      @collections.each do |collection|
        @total += 1
      end
    end
  end

  def create_collection
    @collection = Collection.create(name: params[:name], description: params[:description], category: params[:category], owner_id: current_user.id)
    @collection.save

    unless params[:field_name].nil?
      params[:field_name].each_with_index do |name, index|
        @fields = CustomField.create(field_name: name, field_type: params[:field_type][index], collection_id: @collection.id)
        @fields.save
      end
    end
    redirect_to users_collections_management_path
  end

  def view_collection
    @collection = Collection.find_by(id: params[:format])
    @fields = CustomField.where(collection_id: @collection.id)
  end

  def edit_collection
    @collection = Collection.find_by(id: params[:id])
    if @collection.owner_id.to_s == current_user.id.to_s || current_user.status == "admin"
      @fields = CustomField.where(collection_id: @collection.id)
      if params[:change]
        @collection.update(name: params[:name], description: params[:description], category: params[:category], updated_at: Time.now)
        @collection.save
        @fields.each do |field|
          field.destroy
        end
        unless params[:field_name].nil?
          params[:field_name].each_with_index do |name, index|
            @fields = CustomField.create(field_name: name, field_type: params[:field_type][index], collection_id: @collection.id)
            @fields.save
          end
        end
      elsif params[:delete]
        @collection.destroy
        @fields.each do |field|
          field.destroy
        end
      end
    end
    redirect_to users_collections_management_path
  end

  def items_management
    @items = Item.where(owner_id: current_user.id)
    @collection_name = []
    @total = 0
    @items.each do |item|
      @total += 1
      if item.collection_id == 'NA'
        @collection_name << 'NA'
      else
        @collection_name << Collection.find_by(id: item.collection_id).name
      end
    end
  end

  def create_item
    @step = params[:next] ? '2' : params[:save] ? '3' : '1'
    if @step == '1'
      @collections = Collection.where(owner_id: current_user.id)
    elsif @step == '2'
      @collection_id = params[:collection_id]
      @fields = CustomField.where(collection_id: params[:collection_id])
    elsif @step == '3'
      tag_names = params[:tags]
      tag_names.split(',').each do |name|
        if Tag.find_by(name: name.strip).nil?
          tag = Tag.create(name: name.strip)
        else
          tag = Tag.find_by(name: name.strip)
          count = tag.count + 1
          tag.update(count: count)
        end
        tag.save
      end
      @item = Item.create(name: params[:name], tags: params[:tags], collection_id: params[:collection_id], owner_id: current_user.id)
      @item.save
      unless params[:field_value].nil?
        params[:field_value].each_with_index do |value, index|
          @fields_value = CustomFieldValue.create(value: value, field_id: params[:field_id][index], item_id: @item.id)
          @fields_value.save
        end
      end
      redirect_to users_items_management_path
    end
  end

  def view_item
    @item = Item.find_by(id: params[:format])
    if @item.collection_id != "NA"
      @fields_value = CustomFieldValue.where(item_id: @item.id)
      @fields = CustomField.where(collection_id: @item.collection_id)
    end
  end

  def edit_item
    @item = Item.find_by(id: params[:id])
    if @item.owner_id.to_s == current_user.id.to_s || current_user.status == "admin"
      @fields_value = CustomFieldValue.where(item_id: @item.id)
      if params[:update]
        tag_item_count(@item.tags, params[:tags])
        @item.update(name: params[:name], tags: params[:tags], updated_at: Time.now)
        @fields_value.each do |field|
          field.destroy
        end
        unless params[:field_value].nil?
          params[:field_value].each_with_index do |value, index|
            @fields_value = CustomFieldValue.create(value: value, field_id: params[:field_id][index], item_id: @item.id)
            @fields_value.save
          end
        end
        redirect_to request.referer
      elsif params[:delete]
        @item.destroy
        @fields_value.each do |field|
          field.destroy
        end
        redirect_to users_items_management_path
      end
    end
  end

  private
  def valid_admin
    if user_signed_in? && current_user.status == "admin" && current_user.status != "blocked"
      return true
    elsif user_signed_in? && current_user.status != "blocked"
      redirect_to users_dashboard_path
    else
      redirect_to root_path
    end
  end

  def valid_user
    if user_signed_in? && current_user.status != "blocked"
      return true
    else
      redirect_to root_path
    end
  end

  def tag_item_count(oldTags,newTags)
    oldTagArray = oldTags.split(',')
    newTagArray = newTags.split(',')
    oldTagArray.each do |oldTag|
      if !newTagArray.include?(oldTag.strip)
        oldTagCount = Tag.find_by(name: oldTag.strip).count
        oldTagCount -= 1
        Tag.find_by(name: oldTag).update(count: oldTagCount)
      end
    end
    newTagArray.each do |name|
      tag = Tag.find_or_create_by(name: name.strip)
    end
  end
end

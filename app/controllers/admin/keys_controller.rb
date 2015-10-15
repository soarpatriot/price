class Admin::KeysController < Admin::AdminController

  before_action :set_key, only: [:update,:edit,:destroy]
  def index 
    @keys = Key.all
  end

  def new 
    @key = Key.new
  end

  def edit
    
  end

  def update 
     if @key.update key_params
       redirect_to admin_keys_url
     else
       render :edit
     end
   end

   def create 
     @key = Key.new(key_params) 

     if @key.save
       redirect_to admin_keys_url
     else
       render :new
     end

   end
   def destroy
     @key.destroy
     redirect_to admin_keys_url
   end


   def set_key
     @key = Key.find(params[:id])
   end
   def key_params
     params.require(:key).permit(:id,:origin,:api_key, :ktype, :api_secret)
   end

end


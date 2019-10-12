class TipomaquinatsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "64738", except: :index

 #internet:
  #skip_before_filter :verify_authenticity_token  
  skip_before_action :verify_authenticity_token


  before_action :set_tipomaquinat, only: [:show, :edit, :update, :destroy]
  before_action :get_tipomaquinat_params_only, only: [:index]
  

  # GET /tipomaquinats
  # GET /tipomaquinats.json
  def index
    @tipomaquinats = Tipomaquinat.all
    @dalton = get_tipomaquinat_params_only # retotar valor a la vista
  end

  # GET /tipomaquinats/1
  # GET /tipomaquinats/1.json
  def show
  end

  # GET /tipomaquinats/new
  def new
    @tipomaquinat = Tipomaquinat.new
  end

  # GET /tipomaquinats/1/edit
  def edit
  end

  # POST /tipomaquinats
  # POST /tipomaquinats.json
  def create
    @tipomaquinat = Tipomaquinat.new(tipomaquinat_params)
    #@tipomaquinat = Tipomaquinat.new
    #@tipomaquinat.id=401
    #@tipomaquinat.tipomaquina = "KLK" #params.require(:tipomaquinat).permit(:tipomaquina)
    #@tipomaquinat.descripcion = "YOOOO" #params.require(:tipomaquinat).permit(:descripcion)
    #descripcion

   # params.require(:tipomaquinat).permit(:tipomaquina, :descripcion,

    respond_to do |format|
      if @tipomaquinat.save
        format.html { redirect_to @tipomaquinat, notice: 'Tipomaquinat was successfully created.' }
        format.json { render :show, status: :created, location: @tipomaquinat }
      else
        format.html { render :new }
        format.json { render json: @tipomaquinat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipomaquinats/1
  # PATCH/PUT /tipomaquinats/1.json
  def update
    respond_to do |format|
      if @tipomaquinat.update(tipomaquinat_params)
        format.html { redirect_to @tipomaquinat, notice: 'Tipomaquinat was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipomaquinat }
      else
        format.html { render :edit }
        format.json { render json: @tipomaquinat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipomaquinats/1
  # DELETE /tipomaquinats/1.json
  def destroy
    @tipomaquinat.destroy
    respond_to do |format|
      format.html { redirect_to tipomaquinats_url, notice: 'Tipomaquinat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipomaquinat
      @tipomaquinat = Tipomaquinat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipomaquinat_params
     # params.require(:tipomaquinat).permit(:tipomaquina, :descripcion, :tipomaquinat)
      params.require(:tipomaquinat).permit(:tipomaquina, :descripcion) # :tipomaquinat) ESTABA DE MAS?? DEFAULT O NO? CREO QUE NO. OK.
       #params.require(:tipomaquinat).permit(:tipomaquina)
    end

    def get_tipomaquinat_params_only
     # params.require(:tipomaquinat).permit(:tipomaquina, :descripcion, :tipomaquinat)
      params.permit(:tipomaquina)[:tipomaquina] #ESTABA DE MAS?? DEFAULT O NO? CREO QUE NO. OK.
       #params.require(:tipomaquinat).permit(:tipomaquina)
    end

end

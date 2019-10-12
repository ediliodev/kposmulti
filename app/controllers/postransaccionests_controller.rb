class PostransaccionestsController < ApplicationController
  skip_before_action :verify_authenticity_token # arduino json 
  before_action :set_postransaccionest, only: [:show, :edit, :update, :destroy]

  # GET /postransaccionests
  # GET /postransaccionests.json
  def index
    @postransaccionests = Postransaccionest.all
  end

  # GET /postransaccionests/1
  # GET /postransaccionests/1.json
  def show
  end

  # GET /postransaccionests/new
  def new
    @postransaccionest = Postransaccionest.new
  end

  # GET /postransaccionests/1/edit
  def edit
  end

  # POST /postransaccionests
  # POST /postransaccionests.json
  def create
    @postransaccionest = Postransaccionest.new(postransaccionest_params)
    @postransaccionest.cantidad = @postransaccionest.cantidad.split("L")[0] # Esto para Limpiar el String de cantidad de las POG que viene asi: 4.00LEISURETIME ej. ok. ted.

    respond_to do |format|
      if @postransaccionest.save
        format.html { redirect_to @postransaccionest, notice: 'Postransaccionest was successfully created.' }
        format.json { render :show, status: :created, location: @postransaccionest }
      else
        format.html { render :new }
        format.json { render json: @postransaccionest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postransaccionests/1
  # PATCH/PUT /postransaccionests/1.json
  def update
    respond_to do |format|
      if true # @postransaccionest.update(postransaccionest_params) # NO SE PUEDEN ACTUZALIZAR LAS POSTRANSACCIONES POR EL PORTAL WEB POR MOTIVO DE SEG. CONTACTAR ADMIN A BAJO NIVEL PARA ESO. OK. LOGICA DEL CONTROLADOR DESABILIDATA PARA ESOS FINES OK. TED.
        format.html { redirect_to @postransaccionest, notice: 'Postransaccionest NOT PERMITED TO UPDATE WHIS WAY. INCIDENT REPORTED. CONTACT ADMIN.' }
        format.json { render :show, status: :ok, location: @postransaccionest }
      else
        format.html { render :edit }
        format.json { render json: @postransaccionest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postransaccionests/1
  # DELETE /postransaccionests/1.json
  
  def destroy
  
    # @postransaccionest.destroy # NO SE PUEDE ELIMINAR UN POSTTRANSACCION DESDE LA WEB. DEBE CONTACTAR AL ADMIN. (OK TED.)
  
    respond_to do |format|
      format.html { redirect_to postransaccionests_url, notice: 'Postransaccionest cannot be destroyed. Contact admin. Incident Report.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postransaccionest
      @postransaccionest = Postransaccionest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def postransaccionest_params
      params.require(:postransaccionest).permit(:cantidad, :serial)
    end
end

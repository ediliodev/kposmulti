class MaquinatsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "64738", except: :index
  before_action :set_maquinat, only: [:show, :edit, :update, :destroy]

  # GET /maquinats
  # GET /maquinats.json
  def index
    @maquinats = Maquinat.all
  end

  # GET /maquinats/1
  # GET /maquinats/1.json
  def show
  end

  # GET /maquinats/new
  def new
    @maquinat = Maquinat.new
  end

  # GET /maquinats/1/edit
  def edit
  end

  # POST /maquinats
  # POST /maquinats.json
  def create
    @maquinat = Maquinat.new(maquinat_params)

    respond_to do |format|
      if @maquinat.save
        format.html { redirect_to @maquinat, notice: 'Maquinat was successfully created.' }
        format.json { render :show, status: :created, location: @maquinat }
      else
        format.html { render :new }
        format.json { render json: @maquinat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maquinats/1
  # PATCH/PUT /maquinats/1.json
  def update
    respond_to do |format|
      if @maquinat.update(maquinat_params)
        format.html { redirect_to @maquinat, notice: 'Maquinat was successfully updated.' }
        format.json { render :show, status: :ok, location: @maquinat }
      else
        format.html { render :edit }
        format.json { render json: @maquinat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maquinats/1
  # DELETE /maquinats/1.json
  def destroy
    #@maquinat.destroy # NO SE DEBEN DESTRUIR POR LAS RELACIONES EXISTENTES AL MENOS QUE CONFIGUREMOS DEPENDENT DETROY( NO RECOMENDABLE POR EL HISTORIAL DE VENTAS) SOLO DESABILITARLAS => ACTIVA => NO OK. TED.
    @maquinat.activa = "no"
    if @maquinat.save
        respond_to do |format|
          format.html { redirect_to maquinats_url, notice: 'Maquina desactivada. Para activarla nuevamente presione Editar' }
          format.json { head :no_content }
        end
    end # lo del error del .save (en caso que pase) no se considera por ahora, solo el if, para proteger al sw de una exception. ok.
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maquinat
      @maquinat = Maquinat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maquinat_params
      params.require(:maquinat).permit(:tipomaquinat_id, :descripcion, :serial, :activa, :lastseen)
    end
end

class ReportetipoexcellsController < ApplicationController
  before_action :set_reportetipoexcell, only: [:show, :edit, :update, :destroy]

  # GET /reportetipoexcells
  # GET /reportetipoexcells.json
  def index
    @reportetipoexcells = Reportetipoexcell.all
  end

  # GET /reportetipoexcells/1
  # GET /reportetipoexcells/1.json
  def show
  end

  # GET /reportetipoexcells/new
  def new
    @reportetipoexcell = Reportetipoexcell.new
  end

  # GET /reportetipoexcells/1/edit
  def edit
  end

  # POST /reportetipoexcells
  # POST /reportetipoexcells.json
  def create
    @reportetipoexcell = Reportetipoexcell.new(reportetipoexcell_params)

    respond_to do |format|
      if @reportetipoexcell.save
        format.html { redirect_to @reportetipoexcell, notice: 'Reportetipoexcell was successfully created.' }
        format.json { render :show, status: :created, location: @reportetipoexcell }
      else
        format.html { render :new }
        format.json { render json: @reportetipoexcell.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reportetipoexcells/1
  # PATCH/PUT /reportetipoexcells/1.json
  def update
    respond_to do |format|
      if @reportetipoexcell.update(reportetipoexcell_params)
        format.html { redirect_to @reportetipoexcell, notice: 'Reportetipoexcell was successfully updated.' }
        format.json { render :show, status: :ok, location: @reportetipoexcell }
      else
        format.html { render :edit }
        format.json { render json: @reportetipoexcell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reportetipoexcells/1
  # DELETE /reportetipoexcells/1.json
  def destroy
    @reportetipoexcell.destroy
    respond_to do |format|
      format.html { redirect_to reportetipoexcells_url, notice: 'Reportetipoexcell was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reportetipoexcell
      @reportetipoexcell = Reportetipoexcell.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reportetipoexcell_params
      params.require(:reportetipoexcell).permit(:fecha, :in, :out, :net)
    end
end
